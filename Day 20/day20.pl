use v5.30;
use Data::Dumper;
use File::Slurp;

my @numbers = split '\n', read_file('example.txt');
my $len = scalar @numbers;

for (my $i = 0; $i < $len; ++$i) {
  my $number = shift @numbers;
  if ($number eq '0') {
    push @numbers, '0';
    next;
  }
  if ($number =~ qr/^\*/) {
    --$i;
    push @numbers, $number;
    next;
  }
  my @aux;
  my $times = abs($number) % ($len - 1);
  if (!$times) {
    push @numbers, "*$number";
    next;
  }
  if ($number >= 0) {
    for (1 .. $times) {
      push @aux, shift @numbers;
    }
    unshift @numbers, "*$number";
    unshift @numbers, @aux;
  } else {
    for (1 .. $times) {
      unshift @aux, pop @numbers;
    }
    push @numbers, "*$number";
    push @numbers, @aux;
  }
  # say join ',', @numbers;
}

my @pzero = grep { $numbers[$_] eq '0' } (0 .. $#numbers);

# say join ',', @pzero;
# say  $numbers[($pzero[0] + 3000) % $len];
my $num1 = substr $numbers[($pzero[0] + 1000) % $len], 1;
my $num2 = substr $numbers[($pzero[0] + 2000) % $len], 1;
my $num3 = substr $numbers[($pzero[0] + 3000) % $len], 1;

say "$num1 $num2 $num3";
say $num1 + $num2 + $num3;