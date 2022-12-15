use v5.30;
use Data::Dumper;
use File::Slurp;
use List::MoreUtils qw(firstidx);

my @map = map {[split('', $_)] }(split '\n', read_file('day12.txt'));

sub get_coords {
  my $char = shift;
  for my $i (0 .. $#map) {
    my $idx = firstidx {$_ eq $char} @{$map[$i]};
    return ($i, $idx) if $idx != -1;
  }
}

sub is_inside {
  my ($x, $y) = @_;
  return 0 <= $x && $x <= $#map && 0 <= $y && $y < scalar @{$map[0]};
}

my ($sx, $sy, $ex, $ey) = (get_coords('S'), get_coords('E'));
$map[$sx][$sy] = 'a'; $map[$ex][$ey] = 'z';

my @q = ([$sx, $sy, 0]);
my @dx = (1, 0, -1, 0);
my @dy = (0, 1, 0, -1);
my %vis;
$vis{"$sx|$sy"} = 1;

while (@q) {
  my ($fx, $fy, $dist) = @{shift @q};
  for my $d (0 .. 3) {
    my ($vx, $vy) = ($fx + $dx[$d], $fy + $dy[$d]);
    if (is_inside($vx, $vy) && ord($map[$fx][$fy]) + 1 >= ord($map[$vx][$vy]) && !$vis{"$vx|$vy"}) {
      push(@q, [$vx, $vy, $dist + 1]);
      $vis{"$vx|$vy"} = 1;
      if ($vx == $ex && $vy == $ey) {
        say $dist + 1;
        exit 0;
      }
    }
  }
} 