use v5.30;
use Data::Dumper;
use File::Slurp;

my @offsets = (
  [1, 0, 0],
  [0, 1, 0],
  [0, 0, 1],
  [-1, 0, 0],
  [0, -1, 0],
  [0, 0, -1]
);

my %cubes;
for my $line (split '\n', read_file('day18.txt')) {
  $cubes{$line} = 1;
}

my $ans = 0;

for my $cube (keys %cubes) {
  my @coords = split ',', $cube;
  for my $dir (0 .. $#offsets) {
    my @neighbour;
    for my $i (0 .. 2) {
      push @neighbour, $coords[$i] + $offsets[$dir]->[$i];
    }
    ++$ans if !$cubes{join ',', @neighbour};
  }
}
say $ans;