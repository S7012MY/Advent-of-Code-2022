use v5.30;
use Data::Dumper;

open in, 'day6.txt';

my $word = <in>;
my %fr;
my $num_ones = 0;
for my $i (0 .. length($word) - 1) {
  my $chr = substr $word, $i, 1;
  ++$fr{$chr};
  ++$num_ones if $fr{$chr} == 1;
  --$num_ones if $fr{$chr} == 2;

  if ($i > 3) {
    $chr = substr $word, $i - 4, 1;
    --$fr{$chr};
    ++$num_ones if $fr{$chr} == 1;
    --$num_ones if $fr{$chr} == 0;
  }
  if ($num_ones == 4) {
    say $i + 1;
    last;
  }
}