use v5.30;
use Data::Dumper;
use File::Slurp;

my @data = split '\n', read_file('day4.txt');

my $ans = 0;
for my $intervals (@data) {
  my ($a, $b, $x, $y) = (map {split '-', $_ } (split ',', $intervals));
  ++$ans if ($a <= $x && $y <= $b) || ($x <= $a && $b <= $y);
}
say $ans;