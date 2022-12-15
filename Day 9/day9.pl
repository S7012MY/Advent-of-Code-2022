use v5.30;
use Data::Dumper;

open in, 'day9.txt';

sub mht_dist {
  my ($x, $y, $a, $b) = @_;
  return abs($x - $a) + abs($y - $b);
}

my %vis;
my ($hx, $hy, $tx, $ty) = (0, 0, 0, 0);
my %dx = ('U' => -1, 'D' => 1);
my %dy = ('L' => -1, 'R' => 1);

$vis{"$tx|$ty"} = 1;

while (my ($dir, $steps) = split ' ', <in>) {
  for (1 .. $steps) {
    $hx += $dx{$dir};
    $hy += $dy{$dir};
    next if mht_dist($hx, $hy, $tx, $ty) < 2 || (mht_dist($hx, $hy, $tx, $ty) == 2 && $hx != $tx && $hy != $ty);

    if (mht_dist($hx, $hy, $tx, $ty) == 2) {
      $tx += $dx{$dir};
      $ty += $dy{$dir};
    } else {
      if ($hx < $tx) {
        --$tx;
      } else {
        ++$tx;
      }

      if ($hy < $ty) {
        --$ty;
      } else {
        ++$ty;
      }
    }
    $vis{"$tx|$ty"} = 1;
  }
}

say scalar(keys %vis);