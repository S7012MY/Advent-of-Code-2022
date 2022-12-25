use v5.30;
use Data::Dumper;
use File::Slurp;
use List::Util qw(reduce);

my %dig_to_num = ( '=' => - 2, '-' => -1, '0' => 0, '1' => 1, '2' => 2);

sub convert {
  return reduce {$a * 5 + $dig_to_num{$b}} (split '', shift);
}

my $sum = reduce {$a + convert($b)} (0, split '\n', read_file('day25.txt'));

sub rev_convert {
  my $num = shift;
  my ($p5, $sp5) = (1, 0);
  while (1) {
    if (2 * ($p5 + $sp5) >= $num) {
      last;
    }
    $sp5 += $p5;
    $p5 *= 5;
  }
  my $res;
  while ($p5) {
    if ($num >= 2 * $p5 - 2 * $sp5) {
      $res .= '2';
      $num -= 2 * $p5;
    } elsif ($num >= $p5 - 2 * $sp5) {
      $res .= '1';
      $num -= $p5;
    } elsif ($num >= -2 * $sp5) {
      $res .= '0';
    } elsif ($num >= -1 * $p5 - 2 * $sp5) {
      $res .= '-';
      $num += $p5;
    } else {
      $res .= '=';
      $num += 2 * $p5;
    }

    $p5 = int($p5 / 5);
    $sp5 -= $p5;
  }
  return $res;
}

say rev_convert($sum);