use v5.30;
use Data::Dumper;
use List::Util qw(max);

open in, 'day8.txt';

my @trees;

sub is_inside {
  my ($x, $y) = @_;
  return 0 <= $x && $x < scalar @trees && 0 <= $y && $y < scalar @{$trees[0]};
}

sub get_distance {
  my ($x, $y, $dx, $dy) = @_;
  my $height = $trees[$x][$y];
  $x += $dx; $y += $dy;
  my $distance = 1;
  while(is_inside($x, $y)) {
    return $distance if $trees[$x][$y] >= $height;
    ++$distance;
    $x += $dx; $y += $dy;
  }
  return $distance - 1;
}

while (chomp(my $line = <in>)) {
  push @trees, [split '', $line];
}

my $res = 0;
for my $i (0 .. $#trees) {
  for my $j (0 .. @{$trees[0]} - 1) {
    $res = max($res, (get_distance($i, $j, -1, 0) * get_distance($i, $j, 0, -1) * get_distance($i, $j, 1, 0) * get_distance($i, $j, 0, 1)));
  }
}

say $res;