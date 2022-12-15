use v5.30;
use Data::Dumper;

open in, 'day5.txt';

my $no_stacks = 9;
my $regex = '.(.)..' x $no_stacks;
my @stacks;

my @stacks;
while (my $line = <in>) {
  last if $line =~ qr/1/;
  my @matches = ($line =~ qr/$regex/s);
  for my $i (0 .. $no_stacks - 1) {
    push @{$stacks[$i]}, $matches[$i] if $matches[$i] ne ' ';
  }
}

<in>;
while (my $line = <in>) {
  my ($cnt, $from, $to) = $line =~ qr/move ([0-9]+) from ([1-9]) to ([1-9])/s;
  --$to; --$from;
  unshift @{$stacks[$to]}, (splice @{$stacks[$from]}, 0, $cnt);
}

say join '', (map {$_->[0]} @stacks);