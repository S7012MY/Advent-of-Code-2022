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

my @maxs = (0, 0, 0);
my %cubes;
for my $line (split '\n', read_file('day18.txt')) {
  $cubes{$line} = 1;
  my @coords = split ',', $line;
  for my $i (0 .. 2) {
    $maxs[$i] = $coords[$i] if $maxs[$i] < $coords[$i];
  }
}

my $ans = 0;
my %vis;

sub is_outside {
  my @coords = @_;
  for my $i (0 .. 2) {
    return 1 if $coords[$i] < -1 || $coords[$i] > $maxs[$i] + 1;
  }
  return 0;
}

sub dfs {
  my @coords = @_;
  return if $vis{join ',', @coords};
  $vis{join ',', @coords} = 1;
  for my $dir (0 .. $#offsets) {
    my @neighbour;
    for my $i (0 .. 2) {
      push @neighbour, $coords[$i] + $offsets[$dir]->[$i];
    }
    next if is_outside(@neighbour);
    ++$ans if $cubes{join ',', @neighbour};
    dfs(@neighbour) if !$cubes{join ',', @neighbour};
  }
}

dfs($maxs[0] + 1, $maxs[1] + 1, $maxs[2] + 1);

say $ans;