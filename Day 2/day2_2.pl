use v5.30;

open in, 'day2.txt';

my %scores = (
  'A X' => 3,
  'A Y' => 4,
  'A Z' => 8,
  'B X' => 1,
  'B Y' => 5,
  'B Z' => 9,
  'C X' => 2,
  'C Y' => 6,
  'C Z' => 7
);

my $sum = 0;
while (chomp(my $line = <in>)) {
  $sum += $scores{$line};
}
say $sum;