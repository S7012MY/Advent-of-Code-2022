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
for my $round (1 .. 3000000) {
  say $round;
  my %has_elve;
  for my $elve (@elves) {
    my ($i, $j) = ($elve->[0], $elve->[1]);
    $has_elve{"$i|$j"} = 1;
  }

  my %proposals;
  my @proposals;
  for my $elve (@elves) {
    my $stays = 1;
    for my $i (-1 .. 1) {
      for my $j (-1 .. 1) {
        if ($i || $j) {
          my ($ii, $jj) = ($elve->[0] + $i, $elve->[1] + $j);
          if ($has_elve{"$ii|$jj"}) {
            $stays = 0;
            last;
          }
        }
      }
      last unless $stays;
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
        $is_free = 0 if $has_elve{"$ii|$jj"};
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
  # say join ',', (map {$_->[0] . '|' . $_->[1]} @elves);
  # say join ',', (map {$_->[0] . '|' . $_->[1]} @new_elves);
  if (join(',', (map {$_->[0] . '|' . $_->[1]} @elves)) eq join(',', (map {$_->[0] . '|' . $_->[1]} @new_elves))) {
    say "here";
    say $round;
    last;
  }
  @elves = @new_elves;
  $cdir = ($cdir + 1) % 4;
}