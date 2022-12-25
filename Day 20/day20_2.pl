use v5.30;
use Data::Dumper;
use File::Slurp;

my @numbers = split '\n', read_file('day20.txt');
@numbers = map { $_ * 811589153 } @numbers;
my $len = scalar @numbers;

my %fr;
for (my $i = 0; $i < @numbers; ++$i) {
  ++$fr{$numbers[$i]};
  $numbers[$i] = $numbers[$i] . '|' . $fr{$numbers[$i]};
}
my @initial_numbers = @numbers;

for (1 .. 10) {
  for my $number (@initial_numbers) {
    while ($numbers[0] ne $number) {
      push @numbers, shift @numbers;
    }
    shift @numbers;

    my @aux;
    
    my $real_number = (split '\|', $number)[0];
    my $times = abs($real_number) % ($len - 1);
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
  }
  # say join ',', @numbers;
  @numbers = map { substr $_, 1 } @numbers;
  # say join ',', @numbers;
}

my @pzero = grep { $numbers[$_] eq '0|1' } (0 .. $#numbers);

# say join ',', @pzero;
# say  $numbers[($pzero[0] + 3000) % $len];
my $num1 = (split '\|', $numbers[($pzero[0] + 1000) % $len])[0];
my $num2 = (split '\|', $numbers[($pzero[0] + 2000) % $len])[0];
my $num3 = (split '\|', $numbers[($pzero[0] + 3000) % $len])[0];

say "$num1 $num2 $num3";
say $num1 + $num2 + $num3;