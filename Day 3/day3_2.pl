use v5.30;
use Data::Dumper;
use File::Slurp;

my @data = split '\n', read_file('day3.txt');
my $score = 0;
for (my $i = 0; $i < $#data; $i += 3) {
  for my $letter ('a' .. 'z', 'A' .. 'Z') {
    if ($data[$i] =~ qr/$letter/ && $data[$i + 1] =~ qr/$letter/ && $data[$i + 2] =~ qr/$letter/) {
      $score += (ord(lc($letter)) - ord('a') + 1);
      $score += 26 if ($letter eq uc($letter));
    }
  }
}

say $score;

