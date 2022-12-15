use v5.30;
use Data::Dumper;
use File::Slurp;
use String::Scanf;

sub mht {
  my ($x, $y, $a, $b) = @_;
  return abs($x - $a) + abs($y - $b);
}

my %beacons;
my @sensors;
my ($max_dist, $min_x, $max_x) = (0, 2000000000, -2000000000);
for my $line (split '\n', read_file('day15.txt')) {
  my ($sx, $sy, $bx, $by) = sscanf("Sensor at x=%d, y=%d: closest beacon is at x=%d, y=%d", $line);
  my $dist = mht($sx, $sy, $bx, $by);
  $beacons{"$bx|$by"} = 1;
  push @sensors, [$sx, $sy, $dist];

  $max_dist = $dist if $dist > $max_dist;
  $min_x = $sx if $sx < $min_x;
  $max_x = $sx if $sx > $max_x;
}

my $y = 2000000;
my $res = 0;
say "$max_dist $min_x $max_x";
for my $x ($min_x - $max_dist .. $max_x + $max_dist) {
  my $ok = 0;
  for my $sensor (@sensors) {
    if (mht($x, $y, $sensor->[0], $sensor->[1]) <= $sensor->[2] && !$beacons{"$x|$y"}) {
      $ok = 1;
      last;
    }
  }
  $res += $ok;
}

say $res;
