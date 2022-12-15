use v5.30;

open in, 'day2.txt';

my %scores = (
  X => 1,
  Y => 2,
  Z => 3,
  'A X' => 3,
  'B Y' => 3,
  'C Z' => 3,
  'A Y' => 6,
  'B Z' => 6,
  'C X' => 6
);

my $sum = 0;
while (chomp(my $line = <in>)) {
  $sum += $scores{$line} + $scores{ (split ' ', $line)[-1] };
}
say $sum;