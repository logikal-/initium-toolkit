use strict;
use warnings;
use LWP::UserAgent::Determined;
use HTTP::Cookies;
use Exporter;

our @ISA= qw( Exporter );

our @EXPORT_OK = qw( loginInit );
our @EXPORT = qw( loginInit );

sub loginInit($$)
{
    my $email = shift; 
    my $password = shift;
    
    my $cookie_jar = HTTP::Cookies->new(
    file => "initium-cookie.dat",
    autosave => 1,
    ignore_discard=> 1,
    ) or die "Unable to access cookie file: $!";
    my $browser = LWP::UserAgent::Determined->new( requests_redirectable => [ 'GET', 'HEAD', 'POST' ] );
    $browser->cookie_jar($cookie_jar);
    $browser->timing("15,30,90");
    $browser->agent("Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36");
    my $url = "http://playinitium.com/landing.jsp";

    print "[+] Checking if we're logged in\n";
    my $response = $browser->get($url) or die;
    if($response->is_success)
    {
        if($response->decoded_content !~ m/You are currently logged in/)
        {
            print "[+] Not logged in, logging in\n";
        } else { print "[+] Yep, we're logged in\n"; return 0; }
    } else { die $response->status_line; }
    
    $url = "http://www.playinitium.com/ServletUserControl";
    $response = $browser->post($url,
            [
            "type"=>"login",
            "rtn"=>'',
            "email"=>"$email",
            "password"=>"$password",
            ],
        );

    if($response->is_success)
    {
    if($response->decoded_content =~ m/popupMessage\('An error occurred', 'Login failed.'/)
    {
        die("\n[-] Login failed: unknown error\n");
    } else { print "[+] Login successful!\n"; }

    }
    else
    {
        die("[-] Couldn't login: " . $response->status_line."\n");
    }
}
