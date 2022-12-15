use v5.30;
use Data::Dumper;
use File::Slurp;

my @data = split '\n', read_file('day4.txt');

sub is_inside {
  my ($x, $y, $a) = @_;
  return $x <= $a && $a <= $y;
}

my $ans = 0;
for my $intervals (@data) {
  my ($a, $b, $x, $y) = (map {split '-', $_ } (split ',', $intervals));
  ++$ans if is_inside($a, $b, $x) || is_inside($a, $b, $y) || is_inside($x, $y, $a) || is_inside($x, $y, $b);
}
say $ans;