use v5.30;
use Data::Dumper;

open in, 'day8.txt';

my @trees;

sub is_inside {
  my ($x, $y) = @_;
  return 0 <= $x && $x < scalar @trees && 0 <= $y && $y < scalar @{$trees[0]};
}

sub is_visible {
  my ($x, $y, $dx, $dy) = @_;
  my $height = $trees[$x][$y];
  $x += $dx; $y += $dy;
  while(is_inside($x, $y)) {
    return 0 if $trees[$x][$y] >= $height;
    $x += $dx; $y += $dy;
  }
  return 1;
}

while (chomp(my $line = <in>)) {
  push @trees, [split '', $line];
}

my $res = 0;
for my $i (0 .. $#trees) {
  for my $j (0 .. @{$trees[0]} - 1) {
    $res += (is_visible($i, $j, -1, 0) || is_visible($i, $j, 0, -1) || is_visible($i, $j, 1, 0) || is_visible($i, $j, 0, 1));
  }
}

say $res;