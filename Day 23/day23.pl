use v5.30;
use Data::Dumper;
use File::Slurp;
use List::Util qw(min max);

my @elves;
my @lines = split '\n', read_file('day23.txt');
for my $i (0 .. $#lines) {
  push @elves, map { [$i, $_ ]} (grep { substr($lines[$i], $_, 1) eq '#'} (0 .. length($lines[$i]) - 1));
}

my $cdir = 0;
my @di = ([-1, -1, -1], [1, 1, 1], [-1, 0, 1], [-1, 0, 1]);
my @dj = ([-1, 0, 1], [-1, 0, 1], [-1, -1, -1], [1, 1, 1]);
for (1 .. 10) {
  my %proposals;
  my @proposals;
  for my $elve (@elves) {
    my $stays = 1;
    for my $i (-1 .. 1) {
      for my $j (-1 .. 1) {
        if ($i || $j) {
          $stays = 0 if grep {$elve->[0] + $i == $_->[0] && $elve->[1] + $j == $_->[1]} @elves;
        }
      }
    }
    if ($stays) {
      push @proposals, $elve;
      next;
    }
    my $found = 0;
    for my $d (0 .. 3) {
      my $is_free = 1;
      for my $i (0 .. 2) {
        my ($ii, $jj) = ($elve->[0] + $di[($cdir + $d) % 4]->[$i], $elve->[1] + $dj[($cdir + $d) % 4]->[$i]);
        $is_free = 0 if grep {$ii == $_->[0] && $jj == $_->[1]} @elves;
      }
      if ($is_free) {
        my ($ii, $jj) = ($elve->[0] + $di[($cdir + $d) % 4]->[1], $elve->[1] + $dj[($cdir + $d) % 4]->[1]);
        push @proposals, [$ii, $jj];
        ++$proposals{"$ii|$jj"};
        $found = 1;
        last;
      }
    }
    push @proposals, $elve unless $found;
  }
  my @new_elves;
  for my $i (0 .. $#elves) {
    my ($ii, $jj) = ($proposals[$i]->[0], $proposals[$i]->[1]);
    if ($proposals{"$ii|$jj"} < 2) {
      push @new_elves, [$ii, $jj];
    } else {
      push @new_elves, $elves[$i];
    }
  }
  @elves = @new_elves;
  $cdir = ($cdir + 1) % 4;
}

# for my $i (-2 .. 9) {
#   for my $j (-2 .. 9) {
#     if (grep {$_->[0] == $i && $_->[1] == $j} @elves) {
#       print "#";
#     } else {
#       print ".";
#     }
#   }
#   print "\n";
# }
my $mi = min(map {$_->[0]} @elves);
my $Mi = max(map {$_->[0]} @elves);
my $mj = min(map {$_->[1]} @elves);
my $Mj = max(map {$_->[1]} @elves);

say "$mi $Mi $mj $Mj";
my ($di, $dj) = ($Mi - $mi + 1, $Mj - $mj + 1);
say $di * $dj - scalar @elves;
# say Dumper @elves