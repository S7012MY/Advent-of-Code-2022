use v5.30;
use Data::Dumper;
use File::Slurp;

my $file_content = read_file('day3.txt');
my $score = 0;
for my $rucksack (split '\n', $file_content) {
  my $length = length($rucksack) / 2;
  my ($a, $b) = (substr($rucksack, 0, $length), substr($rucksack, $length));
  for my $letter ('a' .. 'z', 'A' .. 'Z') {
    if ($a =~ qr/$letter/ && $b =~ qr/$letter/) {
      $score += (ord(lc($letter)) - ord('a') + 1);
      $score += 26 if ($letter eq uc($letter));
    }
  }
}
say $score;

