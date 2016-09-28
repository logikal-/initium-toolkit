use strict;
use warnings;
use MIME::Base64;
use Switch;
use login;
use market;
use Term::ANSIColor;

my $lg = "ICBfX19fXyAgICAgICBfIF8gICBfICAgICAgICAgICAgICAgIF9fX19fICAgICAgICAgICAgXyBfICAgICAgICAgICAgICAgDQogIFxfICAgXF8gX18gKF8pIHxfKF8pXyAgIF8gXyBfXyBfX18vX18gICBcX19fICAgX19fIHwgfCB8X18gICBfX19fXyAgX18NCiAgIC8gL1wvICdfIFx8IHwgX198IHwgfCB8IHwgJ18gYCBfIFwgLyAvXC8gXyBcIC8gXyBcfCB8ICdfIFwgLyBfIFwgXC8gLw0KL1wvIC9fIHwgfCB8IHwgfCB8X3wgfCB8X3wgfCB8IHwgfCB8IC8gLyB8IChfKSB8IChfKSB8IHwgfF8pIHwgKF8pID4gIDwgDQpcX19fXy8gfF98IHxffF98XF9ffF98XF9fLF98X3wgfF98IHxfXC8gICBcX19fLyBcX19fL3xffF8uX18vIFxfX18vXy9cX1wNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEhhbmQgY29kZWQgd2l0aCBsb3ZlIC0gRnJleWph";

sub printLogo()
{

    system $^O eq 'MSWin32' ? 'cls' : 'clear';
    print colored(decode_base64($lg)."\n", 'bold yellow');
}

printLogo();

my $email;
my $password;
if(!-e "./initium-initfo.dat")
{
    open(my $fh, '>>', "./initium-initfo.dat") or die("Couldn't open file: $!\n");
    close($fh);
}

open(my $fh, '<', "./initium-initfo.dat") or die("Couldn't open file: $!\n");
while(my $line = <$fh>)
{
    if($line =~ m/^{(.*?)}([:{]{0,2})(.*?)([}]{0,1})$/s)
    {
       $email = $1;
       $password = $3;
    }
}
close($fh);
if(!$email || !$password)
{
    if(!$email) { 
    print q(
        [ Login ]

        Enter email: );
    $email = <STDIN>;
    chomp($email);
    }
    printLogo();

    print q(
        [ Login ]
        
        Email: ); print $email;
    print q(
        Enter password: );
    
    $password = <STDIN>;
    chomp($password);

    printLogo();

    print q(
        [ Login ]

        Save this password? [Y/n]: );
    my $savePass = <STDIN>;
    chomp($savePass);
    open(my $fh, '>', "./initium-initfo.dat") or die("Couldn't open file: $!\n");
    if($savePass eq "y" || $savePass eq "Y")
    {
        print $fh "{$email}:{$password}";
    }
    else
    {
        print $fh "{$email}";
    }
    close($fh);
}
printLogo();

print "\n";
loginInit($email, $password);

printLogo();

print color('yellow');
print "Logged in as: $email\n";
print q(
    [ Main Menu ]

    [ 1 ] Market
    [ 2 ] Exit
    );
print "\n\n    : ";

print color('reset');

my $input = <STDIN>;
chomp($input);

printLogo();

switch($input)
{
    case "1"
    {
        market();
    }
    else
    {
        die();
    }
}

print color('reset');

