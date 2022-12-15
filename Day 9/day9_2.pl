use v5.30;
use Data::Dumper;

open in, 'day9.txt';

sub mht_dist {
  my ($x, $y, $a, $b) = @_;
  return abs($x - $a) + abs($y - $b);
}

my %vis;
my @rope;
push @rope, [0, 0] for (1 .. 10);
my %dx = ('U' => -1, 'D' => 1, 'L' => 0, 'R' => 0);
my %dy = ('L' => -1, 'R' => 1, 'U' => 0, 'D' => 0);

$vis{"0|0"} = 1;

while (my ($dir, $steps) = split ' ', <in>) {
  for (1 .. $steps) {
    $rope[0][0] += $dx{$dir};
    $rope[0][1] += $dy{$dir};
    for my $pos (1..9) {
      next if mht_dist($rope[$pos - 1][0], $rope[$pos - 1][1], $rope[$pos][0], $rope[$pos][1]) < 2 
          || (mht_dist($rope[$pos - 1][0], $rope[$pos - 1][1], $rope[$pos][0], $rope[$pos][1]) == 2 && $rope[$pos - 1][0] != $rope[$pos][0] && $rope[$pos - 1][1] != $rope[$pos][1]);

      if (mht_dist($rope[$pos - 1][0], $rope[$pos - 1][1], $rope[$pos][0], $rope[$pos][1]) == 2) {
        --$rope[$pos][0] if $rope[$pos - 1][0] < $rope[$pos][0];
        ++$rope[$pos][0] if $rope[$pos - 1][0] > $rope[$pos][0];

        --$rope[$pos][1] if $rope[$pos - 1][1] < $rope[$pos][1];
        ++$rope[$pos][1] if $rope[$pos - 1][1] > $rope[$pos][1];
      } else {
        if ($rope[$pos - 1][0] < $rope[$pos][0]) {
          --$rope[$pos][0];
        } else {
          ++$rope[$pos][0];
        }

        if ($rope[$pos - 1][1] < $rope[$pos][1]) {
          --$rope[$pos][1];
        } else {
          ++$rope[$pos][1];
        }
      }
    }
    $vis{"$rope[9][0]|$rope[9][1]"} = 1;
  }
}

say scalar(keys %vis);