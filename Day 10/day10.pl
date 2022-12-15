use v5.30;
use Data::Dumper;

open in, 'day10.txt';

my ($cycles, $reg) = (1, 1);
my @target_cycles = (20, 60, 100, 140, 180, 220);
my $res = 0;

while (my ($cmd, $arg) = split ' ', <in>) {
  my ($cycles_increase, $reg_increase) = (1, 0);
  if ($cmd eq 'addx') {
    $reg_increase = $arg;
    $cycles_increase = 2;
  }

  if ($cycles == $target_cycles[0] || $cycles + $cycles_increase > $target_cycles[0]) {
    $res += $target_cycles[0] * $reg;
    shift @target_cycles;

  }
  last if !@target_cycles;
  $cycles += $cycles_increase;
  $reg += $reg_increase;
}

say $res;