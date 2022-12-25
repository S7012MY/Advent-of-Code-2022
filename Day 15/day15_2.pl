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

my $res = 0;
my $max_coord = 4000000;
for (my $x = 0; $x <= $max_coord; ++$x) {
  for (my $y = 0; $y <= $max_coord; ++$y) {
    # say "$x $y";
    my $ok = 1;
    for my $sensor (@sensors) {
      if (mht($x, $y, $sensor->[0], $sensor->[1]) <= $sensor->[2]) {
        my $remaining_dist = $sensor->[2] - abs($x - $sensor->[0]);
        $y = $sensor->[1] + $remaining_dist - 1 if $sensor->[1] + $remaining_dist - 1 > $y;

        $ok = 0;
        last;
      }
    }
    if ($ok) {
      say $x . " " . $y . " " . ($x * 4000000 + $y) if $ok;
      exit 0;
    }
  }
}
