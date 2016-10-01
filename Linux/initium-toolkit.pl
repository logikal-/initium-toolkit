use warnings;
use MIME::Base64;
use Switch;
use login;
use market;
use Term::ANSIColor;
use path;
use travel;
use Term::ProgressBar;
use Time::HiRes qw{ usleep time };

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
    print color('yellow');
    if(!$email) { 
    print q(
        [ Login ]

        Enter email: );
    print color('reset');
    $email = <STDIN>;
    chomp($email);
    }
    printLogo();
    print color('yellow');
    print q(
        [ Login ]
        
        Email: ); print $email;
    print q(
        Enter password: );
    print color('reset');
    
    $password = <STDIN>;
    chomp($password);

    printLogo();
    print color('yellow');
    print q(
        [ Login ]

        Save this password? [Y/n]:
        WARNING: Password will be
        saved in plaintext in file
        "initium-initfo.dat": );
    print color('reset');
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

print color('bold yellow');
print "Logged in as:".color('reset').color('bold')." $email\n";
print color('reset').color('bold yellow');
print q(
    [ Main Menu ]

    );
    print color('reset');
    print color('yellow')."\n    [ 1 ]".color('reset')." Market";
    print color('yellow')."\n    [ 2 ]".color('reset')." Auto Travel";
    print color('yellow')."\n    [ 3 ]".color('reset')." Exit";
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
    case "2"
    {
        my $currentlocation = GetCurrentLocation();
        print colored("Current location: ", 'yellow');
        print colored($currentlocation."\n", 'reset');
	print colored("Enter destination: ", 'yellow');
        print color('reset');
        my $destiny = <STDIN>;
        chomp($destiny);

        printLogo();
        my @absPath = calculatePath($destiny);
        my $startTime = time;
	if(!$absPath[0])
	{
            printLogo();
            print "Path not found\n";
        }
        else
        {
            #Loop through all sets of paths, but `last` it out
            #It's being kept for later
            for my $path (@absPath)
            {
                if(!(@$path[0] eq $currentlocation))
                {
                    printLogo();
                    die "Path not found\n";
                }
                print "\n";
                @$path = reverse @$path;
                pop @$path;
                @$path = reverse @$path;
                foreach my $location (@$path)
                {
                    print colored("[+] ", 'green');
                    print color('reset');
                    print "\rTraveling to $location\n";
                    my $loopNum = 1;
                    my $progressbar = Term::ProgressBar->new({ count => 100, term_width=>30 });
                    my $progressCnt = 0;
                    while(!(Travel($location,$loopNum)))
                    {
                        if($progressCnt >= 100)
                        {
                            $progressbar->update(99);
                        }
                        else
                        {
                            for($progressCnt;$progressCnt < $loopNum * 33;$progressCnt++)
                            {
                                $progressbar->update($progressCnt);
                                usleep(20000);
                            }
                        }
                        $loopNum++;
                    }
                    $progressbar->update(100);print "\r\n";#  print "\r   -  Traveled to $location              \n";
                }
                last;
            }
        }

        print color('bold yellow')."\nARRIVED: ".color('reset').color('bold');
        my $interval = time - $startTime; 
        if($interval > 60)
        {
            print int(($interval+0.5)/60)." mins, ".int(($interval % 60) + 0.5)." seconds elapsed\n";
        }
        else
        {
            print "only ".int($interval + 0.5)." seconds elapsed";
        }
        print color('reset')."\n";
    }
    else
    {
        die();
    }
}

print color('reset');

