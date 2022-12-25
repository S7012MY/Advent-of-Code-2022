use v5.30;
use Data::Dumper;
use File::Slurp;
use String::Scanf;

my $res = 0;
for my $line (split '\n', read_file('day19.txt')) {
  my $idx;
  my @costs = ([0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]);
  ($idx, $costs[0][0], $costs[1][0], $costs[2][0], $costs[2][1], $costs[3][0], $costs[3][2]) 
    = sscanf("Blueprint %d: Each ore robot costs %d ore. Each clay robot costs %d ore. Each obsidian robot costs %d ore and %d clay. Each geode robot costs %d ore and %d obsidian.", $line);
  
  my $max_geode = 0;
  for my $ore_robots (0 .. 3) {
    my @i_robot_order;
    push @i_robot_order, 0 for (1 .. $ore_robots);
    for my $len (1 .. 21) {
      for my $sm (0 .. (1 << $len) - 1) {
        my @robot_order = @i_robot_order;

        my $has1 = 0;
        my $ok = 1;
        my @fr = (0, 0, 0, 0);
        for my $i (0 .. $len - 1) {
          if ($sm & (1 << $i)) {
            push @robot_order, 1;
            $has1 = 1;
            ++$fr[1];
          } else {
            $ok = 0 if !$has1;
            push @robot_order, 2;
            ++$fr[2];
          }
        }

        next if !$ok || $fr[1] > $costs[2][1] || $fr[2] > $costs[3][2];
        # say join ',', @robot_order;
        # my @robot_order = (1, 1, 1, 2, 1, 2);
        # say "GOOD ARRAY" if ($robot_order[0] == 1 && $robot_order[1] == 1 && $robot_order[2] == 1 && $robot_order[3] == 2 && $robot_order[4] == 1 && $robot_order[5] == 2 && @robot_order == 6);
        my @resources = (0, 0, 0, 0);
        my @robots = @resources;
        $robots[0] = 1;
        for my $minute (1 .. 24) {
          my @new_resources = @resources;
          $new_resources[$_] += $robots[$_] for (0 .. 3);
          if (@robot_order && $resources[0] >= $costs[$robot_order[0]][0] && $resources[1] >= $costs[$robot_order[0]][1] && $resources[2] >= $costs[$robot_order[0]][2] && $resources[3] >= $costs[$robot_order[0]][3]) {
            $new_resources[0] -= $costs[$robot_order[0]][0];
            $new_resources[1] -= $costs[$robot_order[0]][1];
            $new_resources[2] -= $costs[$robot_order[0]][2];
            $new_resources[3] -= $costs[$robot_order[0]][3];
            ++$robots[$robot_order[0]];
            shift @robot_order;
          }

          if (scalar @robot_order == 0 && $resources[0] >= $costs[3][0] && $resources[1] >= $costs[3][1] && $resources[2] >= $costs[3][2] && $resources[3] >= $costs[3][3]) {
            $new_resources[0] -= $costs[3][0];
            $new_resources[1] -= $costs[3][1];
            $new_resources[2] -= $costs[3][2];
            $new_resources[3] -= $costs[3][3];
            ++$robots[3];
          }
          @resources = @new_resources;
          $max_geode = $resources[3] if $max_geode < $resources[3];

          # if ($robot_order[0] == 1 && $robot_order[1] == 1 && $robot_order[2] == 1 && $robot_order[3] == 2 && $robot_order[4] == 1 && $robot_order[5] == 2) {
          #   say "minute: $minute";
          #   say join "|", @robots;
          #   say join "#", @resources;
          #   say "$resources[0] >= $costs[3][0] && $resources[1] >= $costs[3][1] && $resources[2] >= $costs[3][2] && $resources[3] >= $costs[3][3]";
          #   exit if $minute == 24;
          # }
        }
      }
    }
  }
  say $max_geode;
  $res += $idx * $max_geode;
}

say $res;