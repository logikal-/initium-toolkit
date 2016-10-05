use strict;
use warnings;
use LWP::UserAgent::Determined;
use HTTP::Cookies;
use Exporter;
use Term::ProgressBar;
use Term::ANSIColor;
use Time::HiRes qw{ usleep };

our @ISA= qw( Exporter );

our @EXPORT_OK = qw( Travel );
our @EXPORT = qw( Travel );
our $verify;
our $currentlocation;
sub Travel($$);

sub GetCurrentLocation2()
{
    my $cookie_jar = HTTP::Cookies->new(
    file => "initium-cookie.dat",
    autosave => 1,
    ignore_discard=> 1,
    ) or die "Unable to access cookie file: $!";
    my $browser = LWP::UserAgent::Determined->new( requests_redirectable => [ 'GET', 'HEAD', 'POST' ] );
    $browser->cookie_jar($cookie_jar);
    $browser->timing("15,30,90");
    $browser->agent("Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36");
    my $url = "http://playinitium.com/main.jsp";
    my $response = $browser->get($url);
    #retrieve our current location
    if($response->is_success)
    {
        if($response->decoded_content =~ m/Sans-serif;'>(\d{1,2})\/(\d{1,2})<\/p>/)
        {
            my $currentHealth = $1;
            my $maxHealth = $2;
            if($currentHealth < $maxHealth*0.75)
            {
                die "Health is below 75%, dying\n";
            }
        }
        else
        {
            die "Could not get health\n";
        }
        if($response->decoded_content =~ m/antiBotQuestionPopup/)
        {
            die("[-] Antibot captcha detected. Open the home page in your browser.\n");
        }                                    
        if($response->decoded_content =~ m/location above-page-popup'><a href='main.jsp'>(.*)<\/a><\/div>/)
        {
            $currentlocation = $1;
            if($currentlocation =~ m/^Combat site/)
            {
                RetreatSingleCombatTravel();
            }
        } else { die "Couldn't get current location\n"; }
        if($response->decoded_content =~ m/window.verifyCode = "(.*)"/)
        {
            $verify = $1;
        } else { die "Couldn't get verify\n"; }
    }
    return $currentlocation;
}

sub RetreatSingleCombatTravel()
{
    print "\r -   ".color('red')."[-]".color('reset')." Entered combat, retreating     \n";
    my $cookie_jar = HTTP::Cookies->new(
    file => "initium-cookie.dat",
    autosave => 1,
    ignore_discard=> 1,
    ) or die "Unable to access cookie file: $!";
    my $browser = LWP::UserAgent::Determined->new( requests_redirectable => [ 'GET', 'HEAD', 'POST' ] );
    $browser->cookie_jar($cookie_jar);
    $browser->timing("15,30,90");
    $browser->agent("Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36");
    my $inCombat = 1;
    while($inCombat)
    {
#retrieve the main page
        my $url = "http://playinitium.com/main.jsp";
        my $response = $browser->get($url);

        #retrieve our current location
        if($response->is_success)
        {
            if($response->decoded_content =~ m/location above-page-popup'><a href='main.jsp'>(.*)<\/a><\/div>/)
            {
                $currentlocation = $1;    
                if($currentlocation =~ m/(Giant ogre|Protector)/i)
                {
                    printLogo();
                    my $boss = $currentlocation;
                    $boss =~ s/^Combat site: //;
                    print color('bold red')." ENCOUNTERED BOSS: $boss\n".color('reset');
                    while(1)
                    {
                        print "\r ".color('bold red')."[!] BOSS ENCOUNTER [!]";
                        usleep(500000);
                        system('(( speaker-test -t sine -f 800 )& pid=$! ; sleep 0.5s ; kill -9 $pid) > /dev/null');
                        print "\r ".color('reset bold')."[!] BOSS ENCOUNTER [!]";
                        usleep(500000);
                        system('(( speaker-test -t sine -f 2000 )& pid=$! ; sleep 0.5s ; kill -9 $pid) > /dev/null');
                    }
                }
            } else { die "Couldn't get current location\n"; }
            if($response->decoded_content =~ m/window.verifyCode = "(.*)"/)
            {
                my $verify = $1;
            } else { die "Couldn't get verify\n"; }
            if($response->decoded_content =~ m/battle is over now/)
            {
            }
        } else { die $response->status_line; }

        if($currentlocation =~ m/^Combat site/ && $response->decoded_content !~ m/battle is over now/s)
        {
            $url = "http://playinitium.com/ServletCharacterControl?type=escape&v=".$verify;
            #print "[-] Trying to retreat from battle\n";
            $response = $browser->get($url) or die $response->status_line;
        }
        elsif($response->decoded_content !~ m/battle is over now/s)
        {
            print color('red')." -   [!]".color('reset')." Retreated from battle\n";
            $inCombat = 0;
            last;
        }
        if($response->decoded_content =~ m/battle is over now/s)
        {
            if($response->decoded_content =~ m/leaveAndForgetCombatSite\((\d{14,18}?)\)/)
            {
                my $pathId = $1;
                $url = "https://www.playinitium.com/ServletCharacterControl?type=gotoAndForget&pathId=$pathId&v=".$verify;
                $response = $browser->get($url) or die $response->content.$response->status_line;
            }
            else
            {
                print "Couldn't find path ID to leave combat site\n";
                die();
            }
        }
    }
}

sub Travel($$)
{
    usleep(100000);
    my $returnValue = 0;
    my $gotoAscii = shift;
    my $loopNum = shift;
    my $goto;
    my $cookie_jar = HTTP::Cookies->new(
    file => "initium-cookie.dat",
    autosave => 1,
    ignore_discard=> 1,
    ) or die "Unable to access cookie file: $!";
    my $browser = LWP::UserAgent::Determined->new( requests_redirectable => [ 'GET', 'HEAD', 'POST' ] );
    $browser->cookie_jar($cookie_jar);
    $browser->timing("5,10,20");
    $browser->agent("Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36");
    my $url = "http://www.playinitium.com/main.jsp";
    my $response = $browser->get($url);
    if($response->is_success)
    {
        usleep(50000);
        if($response->decoded_content =~ m/antiBotQuestionPopup/)
        {
            die("[-] Antibot captcha detected. Open the home page in your browser.\n");
        }
        if($response->decoded_content =~ m/location above-page-popup'><a href='main.jsp'>(.*)<\/a><\/div>/)
        {
            $currentlocation = $1;
            if($currentlocation =~ m/^Combat site/)
            {
                RetreatSingleCombatTravel();
                sleep(2);
                print color('green')." -   [+]".color('reset')." Completing travel\n";
                while(Travel($gotoAscii, 1) == 0)
                {
                }
                return 1;
            }
            if($currentlocation eq $gotoAscii)
            {
                return 1;
            }
            elsif($gotoAscii eq "Squeeze through" && $currentlocation eq "Claw Marked Crevice")
            {
                return 1;
            }
            elsif($gotoAscii eq "Head back down the mountain" && $currentlocation eq "Grand Mountain")
            {
                return 1;
            }
            elsif($gotoAscii eq "Storm the Black Fort gates" && $currentlocation eq "Black Forest")
            {
                return 1;
            }
        } else { die "Couldn't get current location\n"; }
        if($response->decoded_content =~ m/window.verifyCode = "(.*)"/)
        {
            $verify = $1;
        } else { die "Couldn't get verify\n"; }
        if($loopNum == 1)
        {
            if($response->decoded_content =~ m/doGoto\(event, (\d{14,18})\)(.{80,200}?)<\/span>(.{0,14}?)$gotoAscii/) 
            {
                #print "[+] Traveling to $gotoAscii via $1\n";
                $goto = $1;
            }
            else
            {
                #print "\rCould not find $gotoAscii path ID @ $currentlocation\n";
                findExplore($gotoAscii, $currentlocation, $verify);
                return 1;
            }
        }
    }
    if(1)
    {
        if($goto)
        {
            $url = "http://playinitium.com/ServletCharacterControl?type=goto_ajax&pathId=".$goto."&attack=false&v=".$verify;
        }
        else
        {
            $url = "http://playinitium.com/ServletCharacterControl?type=goto_ajax&pathId=&attack=false&v=".$verify;
        }
        $response = $browser->get($url);
        if($response->is_success)
        {
            #print $response->content."\n";
            if($response->decoded_content =~ m/^\{"isComplete":false/)
            {
                
                if($response->decoded_content =~ m/"timeLeft":(\d)/)
                {
                    
                    if($1 > 4)
                    {
                        usleep(2500000);
#                        my $max = 50;
#                        my $progress = Term::ProgressBar->new( { count => $max, term_width => 30 } );
#                        for (0..$max)
#                        {
#                            my $is_power = 0;
#                            for(my $i = 0; 2**$i <= $_; $i++) 
#                            {
#                                $is_power = 1
#                                if 2**$i == $_;
#                            }
#                            usleep(55000);
#                            $progress->update($_)
#                        }
                    }
                    else { sleep(1); }
                }
            }
            elsif($response->decoded_content =~ m/^\{"isComplete":true/)
            {
                if($currentlocation eq $gotoAscii)
                {
                    $returnValue = 1;
                }
            }
            if($response->content =~ m/You are already performing/)
            {
                sleep(3);
                GetCurrentLocation2();
                sleep(5);
                $url = "http://playinitium.com/ServletCharacterControl?type=cancelLongOperations&v=".$verify;
                $response = $browser->get($url);
                if(!($response->is_success))
		{
                    die($response->status_line);
		}
            }
        } else { die $response->content.$response->status_line; }
    }
    return $returnValue;
}

sub findExplore($$$)
{
    my $gotoAscii = shift;
    my $startLocation = shift;
    my $verify = shift;
    my $cookie_jar = HTTP::Cookies->new(
        file => "initium-cookie.dat",
        autosave => 1,
        ignore_discard=> 1,
        ) or die "Unable to access cookie file: $!";
    my $browser = LWP::UserAgent::Determined->new( requests_redirectable => [ 'GET', 'HEAD', 'POST' ] );
    $browser->cookie_jar($cookie_jar);
    $browser->timing("15,30,90");
    $browser->agent("Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36");
    if($gotoAscii =~ m/\(Explore for Bosses\)/)
    {
        print color('reset green')."\r - [+]".color('reset')." Searching for bosses\n";
    }
    else
    {
        print color('reset green')."\r -  [+]".color('reset')." Exploring to find $gotoAscii\n";
    }
    my $doneExploring = 0;
    my $exploreCnt = 0;
    while($doneExploring == 0)
    {
        $exploreCnt++;
        if($exploreCnt > 50)
        {
#            print color('yellow bold')."ATTN: ".color('reset bold')."Tried exploring more than 50 times, dying\n".color('reset');
        }
        my $currentlocation = GetCurrentLocation2();
        if(!($currentlocation eq $startLocation))
        {
            if($currentlocation eq $gotoAscii)
            {
                print color('green')."\r[+] ".color('reset')."Found $gotoAscii\n";
                last;
            }
            else
            {
                print color('reset red')."\r[!]".color('reset')." Found $currentlocation, returning to $startLocation\n";
                my $attemptCnt = 0;
                if($currentlocation =~ m/^Destroyed camp/)
                {
                    my $url = "http://playinitium.com/main.jsp";
                    my $response = $browser->get($url);
                    if($response->is_success)
                    {
                        if($response->decoded_content =~ m/leaveAndForgetCombatSite\((\d{14,18}?)\)/)
                        {
                            my $pathId = $1;
                            $url = "https://www.playinitium.com/ServletCharacterControl?type=gotoAndForget&pathId=$pathId&v=".$verify;
                            $response = $browser->get($url) or die $response->content.$response->status_line;
                        }
                        else
                        {
                            print "Could not find path ID to leave destroyed camp\n";
                            die();
                        }
                    }
                    else
                    {
                        print "Could not get main.jsp\n";
                        die();
                    }
                }
                else
                {
                    while(!(Travel($startLocation, 1)))
                    {
                         $attemptCnt++;
                         die "\n[-] Unknown travel error" if $attemptCnt > 10;
                    }
                }
            }
        } sleep(2);
        my $url =  "http://playinitium.com/ServletCharacterControl?type=explore_ajax&ignoreCombatSites=true&v=".$verify;
        my $response = $browser->get($url);
        if($response->is_success)
        {
            my $content = $response->decoded_content;
            if($content =~ m/^\{"isComplete":true/)
            {}
            elsif($content =~ m/currently in combat/)
            {
                RetreatSingleCombatTravel();
            }
            elsif($content =~ m/^\{"isComplete":false/)
            {}
            else
            {
                die "Failed to get proper exploration status\n";
            }
            if($content =~ m/"timeLeft":(\d)/)
            {
                print "\r[~] Attempt #$exploreCnt";
                my $timeLeft = $1;
                sleep(1) if $timeLeft > 3;
                sleep(1);
            }
        }
        else
        {
            die $response->content.$response->status_line;
        }
    }
}

1;
