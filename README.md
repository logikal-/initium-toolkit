#Initium Toolkit 

##Auto-travel


 - Features dijkstra's pathfinding algorithm

 - ~20% of map completed
   
 - Will automatically explore if a location on the path hasn't been discovered

 - Checks health, the bot will stop if your health falls below 75%


##Market searcher/buyer


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


##Troubleshooting

If you're having issues in Windows, open a command prompt. You can open a command
prompt by opening your start menu and searching for 'cmd'. Run the program from
within the command prompt by either dragging the icon into the window, or typing 'perl' followed
by the path to the file, like this:

    perl C:/Users/Someone/Desktop/initium-toolkit.pl

If the error is related to barewords, re-download the toolkit from GitHub. If it's anything else,
report it to me directly and I'll fix it ASAP.
