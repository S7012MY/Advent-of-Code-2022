use v5.30;
use Data::Dumper;
use File::Slurp;

my %map;
my $max_y = 0;

sub draw {
  my ($sx, $sy, $ex, $ey) = @_;
  my ($dx, $dy) = 0;
  $dx = 1 if $sx < $ex;
  $dx = -1 if $sx > $ex;

  $dy = 1 if $sy < $ey;
  $dy = -1 if $sy > $ey;
  while ($sx != $ex || $sy != $ey) {
    $map{"$sx|$sy"} = 1;
    $sx += $dx;
    $sy += $dy;
  }
  $max_y = $sy if $max_y < $sy;
  $map{"$sx|$sy"} = 1;
}

for my $line (split '\n', read_file('day14.txt')) {
  my @points = split ' -> ', $line;
  for my $i (1 .. $#points) {
    draw(split(',', $points[$i - 1]), split(',', $points[$i]));
  }
}

for my $i (0 .. 1000) {
  my ($sx, $sy) = (500, 0);
  while(1) {
    if ($sy > $max_y) {
      say $i;
      exit;
    }
    ++$sy;
    if (!$map{"$sx|$sy"}) {
      next;
    }
    --$sx;
    if (!$map{"$sx|$sy"}) {
      next;
    }
    $sx += 2;
    if (!$map{"$sx|$sy"}) {
      next;
    }

    --$sx;
    --$sy;
    $map{"$sx|$sy"} = 1;
    last;
  }
}
