#Initium Toolkit 

##Main feature: Auto-travel


 - Features dijkstra's pathfinding algorithm

 - ~20% of map completed
   
 - Will automatically explore if a location on the path hasn't been discovered

 - Checks health, the bot will stop if your health falls below 75%


##Secondary feature: market searcher/buyer


 - Search by partial or full name, ie "prot"
  
 - Searches every store at your current location

 - Optionally, buy items

 - Displays item stats; dex pen, block chance, dmg reduction, etc.

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
    
