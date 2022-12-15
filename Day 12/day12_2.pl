use v5.30;
use Data::Dumper;
use File::Slurp;
use List::Util qw(min);
use List::MoreUtils qw(firstidx);

my @map = map {[split('', $_)] }(split '\n', read_file('day12.txt'));

sub get_coords {
  my $char = shift;
  my @as;
  for my $i (0 .. $#map) {
    for my $j (0 .. @{$map[$i]} - 1) {
      push @as, [$i, $j] if $map[$i][$j] eq $char;
    }
  }
  return @as;
}

sub is_inside {
  my ($x, $y) = @_;
  return 0 <= $x && $x <= $#map && 0 <= $y && $y < scalar @{$map[0]};
}

my ($sx, $sy, $ex, $ey) = (@{(get_coords('S'))[0]}, @{(get_coords('E'))[0]});
$map[$sx][$sy] = 'a'; $map[$ex][$ey] = 'z';

sub get_dist {
  my ($sx, $sy) = @_;
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
          return $dist + 1;
        }
      }
    }
  }
  return 1000000;
}

my $res = 100000;
for my $pos (get_coords('a')) {
  $res = min($res, get_dist($pos->[0], $pos->[1]));
}

say $res;