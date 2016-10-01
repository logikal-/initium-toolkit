#Initium Toolkit 

Pathfinding is fully setup, but I don't have the entire map recorded yet. It's going to take a while - if you want to see what I mean, look in path.pm
Right now you can auto travel to mostly anywhere east of Aera and from Aera to Valentis. I'm working on it, probably 3 or 4 weeks to map completion

##Installation instructions:

### Windows

Install ActivePerl:

http://www.activestate.com/activeperl

Use the included Perl Package Manager to install the required modules:

    Term::ANSIColor

    Term::ProgressBar

    LWP::UserAgent::Determined

    Switch

    Time::HiRes

Run initium-toolkit.pl by double clicking on it

### Linux

Use your package manager to install cpan, eg.:

    pacman -S cpan

    apt-get install cpan

Use cpan to install the required modules:

    Term::ANSIColor

    Term::ProgressBar

    LWP::UserAgent::Determined
    
    Switch
    
    Time::HiRes

to start the program:

    perl initium-toolkit.pl
    
