use pathAlgorithm;
use LWP::UserAgent::Determined;
use HTTP::Cookies;
use Term::ANSIColor;
use Time::HiRes qw { usleep };

my %initiumMap =
(
    "Aera" => {"North West Hills" => 1, "Aera Countryside" => 1, "Inn" => 1, "Town Hall" => 1, "Artius River" => 1 },
    "Aera Inn" => { "Leave the Inn" => 1 },
    "North West Hills" => { "Aera" => 1, "Canyonside Plains" => 2, "Cricketon Cave" => 2, "The Fork" => 1 },
    "Canyonside Plains" => { "Sun Baked Canyon" => 1, "North West Hills" => 1},
    "Sun Baked Canyon" => { "Canyon Cave Entrance" => 1, "Canyonside Plains" => 1 },
    "Canyon Cave Entrance" => { "Immense Cavern" => 1, "Sun Baked Canyon" => 1, "Old Canyon Quarry" => 1 },
    "Old Canyon Quarry" => { "Canyon Cave Entrance" => 1 },
    "Immense Cavern" => { "Squeeze through" => 1, "Canyon Cave Entrance" => 1 },
    "Squeeze through" => { "Immense Cavern" => 1, "Drake Cave" => 1 },
    "Claw Marked Crevice" => { "Immense Cavern" => 1, "Drake Cave" => 1 },
    "Drake Cave" => { "Claw Marked Crevice" => 1, "Charred Cavern" => 1 },
    "Charred Cavern" => { "Drake Cave" => 1 },
    "Aera Countryside" => { "Giant Turtle" => 2, "Aera Swamplands" => 1, "Troll Camp" => 1, "Wildeburn Forest" => 1, "Northern Hills" => 2, "Aera" => 1 },
    "Northern Hills" => { "Aera Countryside" => 1, "Shadow of a Behemoth" => 2, "Great Northern Valley" => 1 },
    "Shadow of a Behemoth" => { "Northern Hills" => 1 },
    "Giant Turtle" => { "Aera Countryside" => 1 },
    "Aera Swamplands" => { "Aera Countryside" => 1, "Troll Camp" => 1, "Grand Mountain" => 1 },
    "Cricketon Cave" => { "Underground Stream" => 1, "Infested Tunnel" => 1 },
    "Underground Stream" => { "Cricketon Cave" => 1 },
    "Infested Tunnel" => { "Cricketon Cave" => 1, "Baron Cricketon's Lair" => 2 },
    "Baron Cricketon's Lair" => { "Infested Tunnel" => 1 },
    "Wildeburn Forest" => { "Aera Countryside" => 1, "Taelhollow Swamp" => 1 },
    "Taelhollow Swamp" => { "Wildeburn Forest" => 1, "Taelhollow Swamp Shrine" => 1, "Taelhollow Hut" => 1 },
    "Taelhollow Swamp Shrine" => { "Taelhollow Swamp" => 1 },
    "Taelhollow Hut" => { "Taelhollow Swamp" => 1 },
    "Troll Camp" => { "Aera Swamplands" => 1, "Troll Cave Entrance" => 1 },
    "Troll Cave Entrance" => { "Troll Cave" => 1, "Troll Camp" => 1 },
    #todo: troll caves
    "Grand Mountain" => { "Ancient Phoenix" => 2, "Grand Mountain Summit" => 1, "Desert" => 1, "Aera Swamplands" => 1 },
    "Desert" => {"Grand Mountain" => 1, "Sand Swept Valley" => 1, "North Mountain Range" => 1, "Cliffside Lookout" => 1 },
    "Sand Swept Valley" => { "Desert" => 1 },
    "Ancient Phoenix" => { "Grand Mountain" => 1 },
    "Grand Mountain Summit" => { "Head back down the mountain" => 5, "Frozen Cavern" => 2 },
    "Head back down the mountain" => { "Grand Mountain" => 1, "Frozen Cavern" => 2 },
    "Frozen Cavern" => { "Grand Mountain Summit" => 1 },
    "North Mountain Range" => { "Desert" => 1, "Black Mountain" => 1, "North Mountain Range Stone Tower" => 1 },
    "Hidden Pass" => { "Black Mountain" => 1, "Eastern Desert" => 1 },
    "North Mountain Range Stone Tower" => { "North Mountain Range" => 1 },
    "Black Mountain" => { "North Mountain Range" => 1, "Hidden Pass" => 2, "Narrow Stairway" => 1, "Black Forest" => 1 },
    "Narrow Stairway" => { "Black Mountain" => 1 },
    "Black Forest" => { "Black Mountain" => 1, "Storm the Black Fort gates" => 1 },
    "Storm the Black Fort gates" => { "Black Forest" => 2, "Throne Room" => 1 },
    "Fort Black" => { "Black Forest" => 1, "Throne Room" => 1 },
    "Throne Room" => { "Fort Black" => 1, "Panic Room" => 2 },
    "Panic Room" => { "Throne Room" => 1, "Black Forest" => 1 },
    "Cliffside Lookout" => { "Desert" => 1, "Rocky Path" => 1 },
    "Rocky Path" => { "Hydra" => 2, "Cliffside Lookout" => 1, "Mountain Plains" => 1 },
    "Hydra" => { "Rocky Path" => 1 },
    "Mountain Plains" => {"Rocky Path" => 1, "Mountain Plains Shrine" => 2, "Hermit's Cottage" => 1, "Hobgoblin Tribe Campsite" => 1, "Elven Grove" => 1 },
    "Elven Grove" => { "Mountain Plains" => 1 },
    "Mountain Plains Shrine" => { "Mountain Plains" => 1 },
    "Hobgoblin Tribe Campsite" => { "Mountain Plains" => 1, "Warmongers Tent" => 2 },
    "Warmongers Tent" => { "Hobgoblin Tribe Campsite" => 1 },

    "Hermit's Cottage" => { "Mountain Plains" => 1, "Hermit's Dark Basement" => 1 },
    "Hermit's Dark Basement" => { "Hermit's Cottage" => 1, "Marcusville" => 1 },
    "Marcusville" => { "Hermit's Dark Basement" => 1, "Marcus Museum" => 1 },
    "Marcus Museum" => { "Marcusville" => 1 },
    "Great Northern Valley" => { "Overgrown Path" => 1, "Northern Hills" => 1 },
    "Overgrown Path" => { "Great Northern Valley" => 1, "Mystic Temple Ruins" => 1, "Outer Gate" => 1 },
    "Mystic Temple Ruins" => { "Overgrown Path" => 1 },
    "Outer Gate" => { "Overgrown Path" => 1, "Castle Grounds" => 1 },
    "Castle Grounds" => { "Outer Gate" => 1, "Castle Courtyard" => 1 },
    "Castle Courtyard" => { "Castle Grounds" => 1, "Abandoned Castle" => 1 },
    "Abandoned Castle" => { "Secret Passage" => 1, "Castle Courtyard" => 1 },
    "Secret Passage" => { "Abandoned Castle" => 1 },

    
    
   
    "Artius River" => { "Small Creek" => 1, "Artius Lane" => 1, "Aera" => 1 },
    "Small Creek" => { "Artius River" => 1, "Golden Hollow" => 1 },
    "Golden Hollow" => { "Small Creek" => 1, "Stone Tower" => 1 },
    "Stone Tower" => { "Golden Hollow" => 1 },
    "Artius Lane" => { "Misty Forest" => 1, "Artius River" => 1, "Atlas Trail Entrance" => 1 },
    "Misty Forest" => { "Misty Forest Goblin Camp" => 1, "Artius Lane" => 1, "Misty Mountain Basin" => 1 },
    "Atlas Trail Entrance" => {"Artius Lane" => 1, "Jachum's Steps" => 1 },
    "Jachum's Steps" => { "Atlas Trail Entrance" => 1, "Grand Tree Arch" => 1 },
    "Grand Tree Arch" => { "Jachum's Steps" => 1, "River Rock Road" => 1 },
    "River Rock Road" => { "Grand Tree Arch" => 1, "Trail Head" => 1 },
    "Trail Head" => { "River Rock Road" => 1, "Crystal Lake" => 1, "Sapphire Way" => 1 },
    "Misty Forest Goblin Camp" => { "Misty Forest" => 1, "Goblin Tent" => 1, "Leader's Tent" => 2 },
    "Leader's Tent" => { "Misty Forest Goblin Camp" => 1, "A Letter" => 1 },
    "A Letter" => { "Leader's Tent" => 1 },
    "Goblin Tent" => { "Misty Forest Goblin Camp" => 1 },
    "Misty Mountain Basin" => { "Misty Forest" => 1, "Misty Mountain Pass" => 1, "Misty Cave Entrance" => 1 },
    "Misty Cave Entrance" => { "Misty Mountain Basin" => 1 },
    "Misty Mountain Pass" => { "Misty Mountain Basin" => 1, "Steep Mountain Path" => 1, "Frosty's Domain" => 1 },
    "Steep Mountain Path" => { "Misty Mountain Pass" => 1 },
    "Frosty's Domain" => { "Misty Mountain Pass" => 1 },
    "The Fork" => { "Spider Cave Cavern" => 1, "High Road" => 1, "North West Hills" => 1 },
    "Spider Cave Cavern" => { "The Fork" => 1, "Deathly Forest" => 1 },
    "Deathly Forest" => { "Spider Cave Cavern" => 1 },
    "High Road" => { "The Fork" => 1, "High Road: Swampland" => 1 },
    "High Road: Swampland" => { "High Road" => 1, "High Road: Dense Forest" => 1 },
    "High Road: Dense Forest" => { "High Road: Swampland" => 1, "High Road: Forest" => 1 },
    "High Road: Forest" => {"Den of a Slain Beast" => 1, "High Road: Waterfall" => 1, "High Road: Dense Forest" => 1 },
    "Den of a Slain Beast" => { "High Road: Forest" => 1 },
    "High Road: Waterfall" => { "High Road: Forest" => 1, "High Road: Waterfall Clearing" => 1 },
    "High Road: Waterfall Clearing" => { "High Road: Waterfall" => 1, "High Road: Ogre Pass" => 1 },
    "High Road: Ogre Pass" => { "High Road: Waterfall Clearing" => 1, "High Road: Forest Lookout" => 1 },
    "High Road: Forest Lookout" => { "High Road: Ogre Pass" => 1, "High Road: Lake" => 1 },
    "High Road: Lake" => { "High Road: Forest Lookout" => 1, "Volantis River" => 1 },
    "Volantis River" => { "Volantis Countryside" => 1, "Troll Caves" => 1, "High Road: Lake" => 1 },
    "Volantis Countryside" => { "Volantis River" => 1, "Troll Caves" => 1, "Volantis" => 1 },
    "Troll Caves" => { "Volantis Countryside" => 1, "Volantis River" => 1 },
    "Volantis" => {"Volantis Countryside" => 1, "Volantis Inn" => 1, "Volantis Town Hall" => 1, "South Volantis Beach" => 1, "Northern Volantis Coastline" => 1, "Volantis Docks" => 1 },
    "Volantis Inn" => { "Volantis" => 1 },
    "Volantis Town Hall" => { "Volantis" => 1 },
    "Volantis Docks" => { "Volantis" => 1, "Ferry 1" => 1 },
    "Ferry 1" => { "Volantis Docks" => 1, "Ferry 2" => 1 },
    "Ferry 2" => { "Ferry 1" => 1, "Ferry 3" => 1 },
    "Ferry 3" => { "Ferry 2" => 1, "Ferry 4" => 1 },
    "Ferry 4" => { "Ferry 3" => 1, "Eridis Island" => 1 },
    "Eridis Island" => { "Eridis Shores" => 1, "Ferry 4" => 1 },
    "Eridis Shores" => { "Eridis Island" => 1, "The Bay" => 1 },
    "Eridis Forest 1" => { "The Bay" => 1, "Eridis Forest 2" => 1, "Forest Path" => 1 },
    "The Bay" => { "Eridis Shores" => 1, "Eridis Forest 1" => 1 },
    "Eridis Forest 2" => { "Eridis Forest 1" => 1, "Eridis Climb" => 1 },
    "Eridis Climb" => { "Eridis Forest 2" => 1, "Eridis Peak" => 1 },
    "Eridis Peak" => { "Eridis Climb" => 1, "Eridis Lake" => 2 },
    "Eridis Lake" => { "Eridis Peak" => 1 },
    "South Volantis Beach" => { "Volantis" => 1, "Seaside Landing" => 1, "Old Volantis Church Ruins" => 1},
    "Old Volantis Church Ruins" => { "South Volantis Beach" => 1, "Old Cemetery Entrance" => 1 },
    "Old Cemetery Entrance" => { "Family Burial Ground" => 1, "Old Volantis Church Ruins" => 1, "Pet Cemetery" => 1, "North Cemetery" => 1 },
    "Family Burial Ground" => { "Old Cemetery Entrance" => 1 },
    "Pet Cemetery" => { "Old Cemetery Entrance" => 1 },
    "North Cemetery" => { "The Tomb" => 1, "Old Cemetery Entrance" => 1, "Grave Marker" => 1, "Northeast Cemetery" => 1, "Crypt Entrance" => 1 },
    "The Tomb" => { "North Cemetery" => 1 },
    "Grave Marker" => { "North Cemetery" => 1 },
    "Crypt Entrance" => { "North Cemetery" => 1 },
    "Northeast Cemetery" => { "North Cemetery" => 1, "Skeleton Grave" => 1 },
    "Skeleton Grave" => { "Northeast Cemetery" => 1 },
    "Forest Path" => { "Eridis Forest 1" => 1, "Caru Hill" => 1 },
    "Caru Hill" => { "Forest Path" => 1 },
"Crystal Lake" => { "Trail Head" => 1 }, 
"Sapphire Way" => { "Trail Head" => 1,"Rasheek Plains" => 1 }, 
"Rasheek Plains" => { "Sapphire Way" => 1,"Evergreen Trail" => 1 }, 
"Evergreen Trail" => { "Rasheek Plains" => 1,"Dark Wood Pass" => 1 }, 
"Dark Wood Pass" => { "Evergreen Trail" => 1,"Blood Forest" => 1 }, 
"Blood Forest" => { "Dark Wood Pass" => 1,"Nik's Cut-Through" => 1 },
"Nik's Cut-Through" => { "Blood Firest" => 1,"Mountain Pass" => 1 }, 
"Mountain Pass" => { "Nik's Cut-Through" => 1,"Nubark Mountain" => 1 }, 
"Nubark Mountain" => { "Mountain Pass" => 1,"Dragon's Pass" => 1 }, 
"Dragon's Pass" => { "Nubark Mountain" => 1,"Atlas Trail Entrance" => 1 }, 
"Atlas Trail Entrance" => { "Dragon's Pass" => 1,"Cinder Mountain Range" => 1 }, 
"Cinder Mountain Range" => { "Atlas Trail Entrance" => 1,"Cinder Plains" => 1,"Smoldering Mountains" => 1 }, 
"Smoldering Mountains" => { "Core of Smoldering Mountains" => 1,"Cinder Mountain Range" => 1,"Smoldering Mountains Ascent" => 1 }, 
"Core of Smoldering Mountains" => { "Smoldering Mountains" => 1 }, 
"Smoldering Mountains Ascent" => { "Smoldering Mountains" => 1,"Smoldering Mountain Peak" => 1 }, 
"Smoldering Mountain Peak" => { "Smoldering Mountains Ascent" => 1 },
"Cinder Plains" => { "Cinder Mountain Range" => 1,"Dried Lake Bed" => 1,"Eastern Desert 3" => 1 }, 
"Dried Lake Bed" => { "Cinder Plains" => 1,"Windy Expanse" => 1,"Depraved Wilds" => 1 }, 
"Windy Expanse" => { "Dried Lake Bed" => 1 }, 
"Depraved Wilds" => { "Dried Lake Bed" => 1,"Forest Fire 1" => 1,"Shadowed Forest" => 1,"Condemned Cave Entrance" => 1 }, 
"Shadowed Forest" => { "Depraved Wild" => 1 }, 
"Condemned Cave Entrance" => { "Depraved Wilds" => 1,"Rakken Den" => 1 }, 
"Rakken Den" => { "Condemned Cave Entrance" => 1,"Carved Tunnel" => 1 }, 
"Carved Tunnel" => { "Rakken Den" => 1,"Feeding Chamber" => 1 }, 
"Feeding Chamber" => { "Carved Tunnel" => 1,"Larvae Pit" => 1 }, 
"Larvae Pit" => { "Feeding Chamber" => 1 },
"North Volantis Coastline" => { "Nors Mountains" => 1,"Volantis" => 1 },
"Nors Mountains" => { "Gaping Cave" => 1,"Nors Mountains Shrine" => 1,"Sand-Swept Plains" => 1,"Nors Plains" => 1 },
"Gaping Cave" => { "Nors Mountains" => 1 },
"Nors Mountains Shrine" => { "Nors Mountains" => 1 },
"Sand Swept Plains" => { "Nors Mountains" => 1,"Kujir Marsh Entrance" => 1 },
"Nors Plains" => { "Nors Mountains" => 1,"Nortion Hills" => 1,"Kobold Settlement" => 1 },
"Kobold Settlement" => { "Nors Plains" => 1 },
"Nortion Hills" => { "Nors Plains" => 1,"Orc Outpost" => 1 }, 
"Orc Outpost" => { "Nortion Hills" => 1,"Orc Camp 1" => 1 }, 
"Orc Camp 1" => { "Orc Outpost" => 1,"Orc Camp 2" => 1 },
"Orc Camp 2" => { "Orc Camp 1" => 1,"Orc Prince" => 1 },
"Orc Prince" => { "Orc Camp 2" => 1 },

);
my $lg = "ICBfX19fXyAgICAgICBfIF8gICBfICAgICAgICAgICAgICAgIF9fX19fICAgICAgICAgICAgXyBfICAgICAgICAgICAgICAgDQogIFxfICAgXF8gX18gKF8pIHxfKF8pXyAgIF8gXyBfXyBfX18vX18gICBcX19fICAgX19fIHwgfCB8X18gICBfX19fXyAgX18NCiAgIC8gL1wvICdfIFx8IHwgX198IHwgfCB8IHwgJ18gYCBfIFwgLyAvXC8gXyBcIC8gXyBcfCB8ICdfIFwgLyBfIFwgXC8gLw0KL1wvIC9fIHwgfCB8IHwgfCB8X3wgfCB8X3wgfCB8IHwgfCB8IC8gLyB8IChfKSB8IChfKSB8IHwgfF8pIHwgKF8pID4gIDwgDQpcX19fXy8gfF98IHxffF98XF9ffF98XF9fLF98X3wgfF98IHxfXC8gICBcX19fLyBcX19fL3xffF8uX18vIFxfX18vXy9cX1wNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEhhbmQgY29kZWQgd2l0aCBsb3ZlIC0gRnJleWph";

sub printLogo()
{

        system $^O eq 'MSWin32' ? 'cls' : 'clear';
            print colored(decode_base64($lg)."\n", 'bold yellow');
}

sub GetCurrentLocation()
{
    my $currentlocation;
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
        
        if($response->decoded_content =~ m/location above-page-popup'><a href='main.jsp'>(.*)<\/a><\/div>/)
        {
            $currentlocation = $1;
        } else { die "Couldn't get current location\n"; }
        if($response->decoded_content =~ m/window.verifyCode = "(.*)"/)
        {
            $verify = $1;
        } else { die "Couldn't get verify\n"; }
    }
    return $currentlocation;
}


sub calculatePath($)
{
    my $currentlocation = GetCurrentLocation();
    if($currentlocation =~ m/^Combat site/)
    {
        RetreatSingleCombat();
        $currentlocation = GetCurrentLocation();
    }
    my $destiny = shift;
    if($currentlocation eq $destiny)
    {
        print "Already at destination $destiny\n";
        return 0;
    }
    local $| = 1;
    my @origindestFound = (0, 0, "");
    foreach my $vfx (my @keyNames = keys %initiumMap)
    {
        $origindestFound[0] = 1 if $vfx eq $currentlocation;
        $origindestFound[1] = 1 if $vfx eq $destiny;
        last if $origindestFound[0] && $origindestFound[1];
        usleep(8000);
        print "\rPathfinding: $vfx                       ";
    }
    if(!$origindestFound[1])
    {
        my @possibleDests = ();
        foreach my $key (my @keyNames = keys %initiumMap)
        {
            push(@possibleDests, $key) if $key =~ m/$destiny/i;
        }
        if($#possibleDests > 1)
        {
            print color('bold yellow');
            print "\rNo match for ".color('reset').color('bold').$destiny.color('bold yellow').", choose from the following:\n".color('reset');
            my $destCnt = 1;
            foreach my $possibleDest (@possibleDests)
            {
                print color('bold yellow');
                print "$destCnt. ".color('reset').color('bold').$possibleDest."\n".color('reset');
                $destCnt++;
            }
            print color('bold yellow')."> ".color('reset').color('bold');
            my $newDest = <STDIN>;
            chomp($newDest);
            print color('reset');
            printLogo();
            if(@possibleDests[$newDest - 1])
            {
                $destiny = @possibleDests[$newDest- 1];
            }
            else
            {
                print color('bold yellow')."\rDestination ".color('reset').color('bold').$destiny.color('bold yellow')." not found\n".color('reset');
                return 0;
            }
        }
        else
        {
            print color('bold yellow');
            print "\rFound ".color('reset').color('bold').@possibleDests[0].color('bold yellow')." for partial name ".color('reset').color('bold').$destiny."\n";
            $destiny = @possibleDests[0];
            color('reset');
        }
        
    }
    print "\r                                               \r";

    my $pathObj = pathAlgorithm->new(-origin=>$currentlocation,-destiny=>$destiny,-graph=>\%initiumMap);
    my @paths = $pathObj->shortest_path();

    my $counter = 0;
    for my $path(@paths) 
    {
        if(!@$path)
        {
            print "No path found";
            return 0;
        }
        my @names = @$path;
        print color('bold yellow')."ORIGIN:".color('reset').color('bold')." $currentlocation\n".color('reset');
        foreach my $location (@names)
        {
            if($location eq $destiny)
            {
                print color('bold yellow')."DEST.:".color('reset').color('bold')." $location\n\n".color('reset');
                print color('bold yellow')."ETA: ".color('reset').color('bold');
                $counter > 2 ? $counter += 2 : $counter += 1;
                my $ETA = ($counter*8)+1;
                $ETA += 3 if $ETA == 9;
                if ($ETA > 60)
                {
                    my $ETAMins = $ETA / 60;
                    my $ETASecs = int(($ETA % 60) + 0.5);
                    printf("%.0f", "$ETAMins"); 
                    print " minute"; print "s" if $ETAMins > 1;
                    print ", $ETASecs seconds\n";
                }
                else
                {
                    print $ETA." seconds\n";
                }
                print color('reset');
                last;
            }
            elsif(!($location eq $currentlocation))
            {
                $counter++;
                usleep(120000);
                print " - $counter. $location\n";
            }
        }
#       print "Cost: ".$pathObj->get_path_cost(@$path)."\n";
        last;
    }
    return @paths;
}

1;
