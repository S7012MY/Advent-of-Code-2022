use v5.30;
use Data::Dumper;

open in, 'day11.txt';
my @monkeys;

sub get_new_idx {
  my ($left, $op, $right, $num) = @_;
  my $a = $left eq 'old' ? $num : $left;
  my $b = $right eq 'old' ? $num : $right;
  return $a * $b if $op eq '*';
  return $a + $b;
}

while (my $monkey_idx = <in>) {
  $monkey_idx = substr $monkey_idx, 7, 1;
  my @items = split(', ', substr(<in>, 18));
  my $operation = <in>;

  $operation =~ qr/Operation: new = (old|[0-9]+) (\*|\+) (old|[0-9]+)/;
  my ($left, $op, $right) = ($1, $2, $3);

  chomp(my $divisor = substr <in>, 21);
  chomp(my ($if_true, $if_false) = (substr(<in>, 29), substr(<in>, 30)));
  <in>;
  $monkeys[$monkey_idx]->{items} = [@items];
  $monkeys[$monkey_idx]->{left} = $left;
  $monkeys[$monkey_idx]->{op} = $op;
  $monkeys[$monkey_idx]->{right} = $right;
  $monkeys[$monkey_idx]->{divisor} = $divisor;
  $monkeys[$monkey_idx]->{if_true} = $if_true;
  $monkeys[$monkey_idx]->{if_false} = $if_false;
}


for (1..20) {
  for my $monkey (@monkeys) {
    while(my $item = shift @{$monkey->{items}}) {
      ++$monkey->{num};
      $item = int(get_new_idx($monkey->{left}, $monkey->{op}, $monkey->{right}, $item) / 3);
      my $new_idx = $monkey->{if_false};
      $new_idx = $monkey->{if_true} if $item % $monkey->{divisor} == 0;

      push @{$monkeys[$new_idx]->{items}}, $item;
    }
  }
}

my @ans = sort {$b <=> $a} map({$_->{num}} @monkeys);
say $ans[0] * $ans[1];