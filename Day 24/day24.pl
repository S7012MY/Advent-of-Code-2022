use v5.30;
use Data::Dumper;
use File::Slurp;

my (@ups, @downs, @lefts, @rights) = @_;

my @lines = split '\n', read_file('day24.txt');
my $n = @lines - 2;
my $m = length ($lines[0]) - 2;

for my $i (0 .. $#lines) {
  for my $j (0 .. length($lines[$i]) - 1) {
    push @{$rights[$i]}, $j - 1 if substr($lines[$i], $j, 1) eq '>';
    push @{$lefts[$i]}, $j - 1 if substr($lines[$i], $j, 1) eq '<';
    push @{$ups[$j]}, $i - 1 if substr($lines[$i], $j, 1) eq '^';
    push @{$downs[$j]}, $i - 1 if substr($lines[$i], $j, 1) eq 'v';
  }
}

my @di = (1, 0, -1, 0);
my @dj = (0, 1, 0, -1);
my @q = ([0, 1, 1]);

my $max_dist = 1000000;
my $max_touches = 5000;
my %touches;

sub is_free {
  my ($i, $j, $dist) = @_;
  return 0 if grep {$_ == ($j - 1 + $dist) % $m } @{$lefts[$i]};
  return 0 if grep {$_ == ($j - 1 - $dist + $max_dist * $m) % $m } @{$rights[$i]};

  return 0 if grep {$_ == ($i - 1 + $dist) % $n} @{$ups[$j]};
  return 0 if grep {$_ == ($i - 1 - $dist + $max_dist * $n) % $n} @{$downs[$j]};
  
  return 1;
}

my %vis;

while (@q) {
  my $fr = shift @q;
  my ($i, $j, $dist) = @{$fr};
  ++$touches{"$i|$j"};
  if ($touches{"$i|$j"} == 1)  {
    # say "$i $j $dist";
  }
  if ($i == $n + 1 && $j == $m) {
    say "Finished!";
    say $dist - 1;
    exit;
  }
  for my $d (0 .. 3) {
    my ($ii, $jj) = ($i + $di[$d], $j + $dj[$d]);
    next if (!$ii || !$jj || $ii == $n + 3 || $jj == $m + 3 || substr($lines[$ii], $jj, 1) eq '#');

    next unless is_free($ii, $jj, $dist);
    next if $touches{"$ii|$jj"} > $max_touches;
    my $d2 = $dist + 1;
    next if $vis{"$ii|$jj|$d2"};
    $vis{"$ii|$jj|$d2"} = 1;
    push @q, [$ii, $jj, $dist + 1];
  }
  
  # say "$i $j $dist";
  next unless is_free($i, $j, $dist);
  my $d2 = $dist + 1;
  next if $vis{"$i|$j|$d2"};
  $vis{"$i|$j|$d2"} = 1;
  push @q, [$i, $j, $dist + 1] if $touches{"$i|$j"} <= $max_touches;
}