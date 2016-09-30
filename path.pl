use path;

my %initiumMap =
(
    "Aera" => {"North West Hills" => 1, "Aera Countryside" => 1, "Inn" => 1, "Town Hall" => 1, "Artius River" => 1},
    "North West Hills" => { "Aera" => 1, "Canyonside Plains" => 2, "Baron Cricketon's Lair" => 2, "Fork" => 1 },
    "Canyonside Plains" => { "Sun Baked Canyon" => 1, "North West Hills" => 1},
    "Sun Baked Canyon" => { "Canyon Cave Entrance" => 1, "Canyonside Plains" => 1 },
    "Canyon Cave Entrance" => { "Immense Cavern" => 1, "Sun Baked Canyon" => 1 },
    "Immense Cavern" => { "Canyon Cave Entrance" => 1, "Claw Marked Crevice" => 1 },
    "Claw Marked Crevice" => { "Immense Cavern" => 1, "Drake Cave" => 1 },
    "Drake Cave" => { "Claw Marked Crevice" => 1, "Charred Cavern" => 1 },
    "Charred Cavern" => { "Drake Cave" => 1 },
    "Aera Countryside" => { "Giant Turtle" => 2, "Aera Swamplands" => 1, "Troll Camp" => 1, "Wildeburn Forest" => 1, "Shadowfallen Northern Hills" => 2, "Aera" => 1 },
    "Shadowfallen Northern Hills" => { "Aera Countryside" => 1, "Shadow of a Behemoth" => 2, "Great Northern Valley" => 1 },
    "Shadow of a Behemoth" => { "Shadowfallen Northern Hills" => 1 },
    "Giant Turtle" => { "Aera Countryside" => 1 },
    "Aera Swamplands" => { "Aera Countryside" => 1, "Troll Camp" => 1, "Grand Mountain" => 1 },
    "Baron Cricketon's Lair" => { "North West Hills" => 1 },
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
    "Grand Mountain Summit" => { "Grand Mountain" => 1, "Frozen Cavern" => 2 },
    "Frozen Cavern" => { "Grand Mountain Summit" => 1 },
    "North Mountain Range" => { "Desert" => 1, "Black Mountain" => 1, "North Mountain Range Stone Tower" => 1 },
    "North Mountain Range Stone Tower" => { "North Mountain Range" => 1 },
    "Black Mountain" => { "North Mountain Range" => 1, "Hidden Pass" => 2, "Narrow Stairway" => 1, "Black Forest" => 1 },
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
    "Great Northern Valley" => { "Shadowfallen Northern Hills" => 1, "Abandoned Castle" => 1 },
    "Abandoned Castle" => { "Great Northern Valley" => 1, "Mystic Temple Ruins" => 2, "Outer Gate" => 1 },
    "Mystic Temple Ruins" => { "Abandoned Castle" => 1 },
    "Outer Gate" => { "Abandoned Castle" => 1, "Castle Grounds" => 1 },
    "Castle Grounds" => { "Outer Gate" => 1, "Outer Walkway" => 1 },
    "Outer Walkway" => { "Castle Grounds" => 1 },
    "Artius River" => { "Artius Lane" => 1, "Aera" => 1 },
    "Artius Lane" => { "Misty Forest" => 1, "Artius River" => 1 },
    "Misty Forest" => { "Goblin Camp" => 1, "Artius Lane" => 1, "Misty Mountain Basin" => 1 },
    "Goblin Camp" => { "Misty Forest" => 1, "Goblin Tent" => 1, "Leader's Tent" => 2 },
    "Leader's Tent" => { "Goblin Camp" => 1, "A Letter" => 1 },
    "A Letter" => { "Leader's Tent" => 1 },
    "Goblin Tent" => { "Goblin Camp" => 1 },
    "Misty Mountain Basin" => { "Misty Forest" => 1, "Misty Mountain Pass" => 1, "Misty Cave Entrance" => 1 },
    "Misty Cave Entrance" => { "Misty Mountain Basin" => 1 },
    "Misty Mountain Pass" => { "Misty Mountain Basin" => 1 },
    "Fork" => { "Spider Cavern" => 1, "High Road" => 1, "North West Hills" => 1 },
    "Spider Cavern" => { "Fork" => 1 },
    "High Road" => { "Fork" => 1, "High Road: Swampland" => 1 },
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

);

print "Enter origin (please be exact, proper capitalization and spelling): ";
my $origin = <STDIN>;
chomp($origin);
print "Enter destination (same deal): ";
my $destiny = <STDIN>;
chomp($destiny);
if($origin eq $destiny)
{
    print "Already at destination $destiny\n";
}
my $g = path->new(-origin=>$origin,-destiny=>$destiny,-graph=>\%initiumMap);

my @paths = $g->shortest_path();

my $counter = 1;
for my $path(@paths) 
{
    if(!@$path)
    {
        print "No path found";
    }
    print "Shortest path found:\n";
    foreach my $location (@$path)
    {
        print "$counter. $location\n";
        $counter++;
    }# . join("\r\n ", @$path) . "\n    Cost:".$g->get_path_cost(@$path) . "\n";
    print "Cost: ".$g->get_path_cost(@$path)."\n";
}
