use v5.30;
use Data::Dumper;

open in, 'day10.txt';

my ($cycles, $reg) = (0, 1);

sub execute_cycle {
  if ($reg - 1 <= $cycles && $cycles <= $reg + 1) {
    print "#";
  } else {
    print ".";
  }
  ++$cycles;
  if ($cycles % 40 == 0) {
    print "\n";
    $cycles = 0;
  }
}

while (my ($cmd, $arg) = split ' ', <in>) {
  my ($cycles_increase, $reg_increase) = (1, 0);
  execute_cycle();
  if ($cmd eq 'addx') {
    execute_cycle();
    $reg += $arg;
  }
}