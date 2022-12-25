use v5.30;
use Data::Dumper;
use File::Slurp;

my (%ops, %values);

sub compute {
  my $s = shift;
  return $values{$s} if $values{$s};
  if ($ops{$s} =~ qr/^([0-9]+)$/) {
    $values{$s} = $1;
    return $1;
  }
  $ops{$s} =~ qr/ (\+|\-|\*|\/) /;
  my $op = $1;
  my ($left, $right) = split qr/ [\+|\-|\*|\/] /, $ops{$s};
  $values{$left} //= compute($left);
  $values{$right} //= compute($right);
  return compute($left) + compute($right) if $op eq '+';
  return compute($left) - compute($right) if $op eq '-';
  return compute($left) * compute($right) if $op eq '*';
  return compute($left) / compute($right) if $op eq '/';
}

for my $line (split '\n', read_file('day21.txt')) {
  my ($name, $params) = split ': ', $line;
  $ops{$name} = $params;
}

say compute('root');