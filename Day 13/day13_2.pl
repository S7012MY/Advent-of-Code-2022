use v5.30;
use Data::Dumper;
use File::Slurp;
use List::Util qw(min);

my $inputs = read_file('day13.txt');
$inputs =~ s/\n\n/\n/g;
my @inputs = split '\n', $inputs;

sub my_split {
  my $str = shift;
  my @res;
  my $current_char;
  my $level = 0;
  for my $char (split '', $str) {
    if ($char eq ',' && $level == 0) {
      push @res, $current_char;
      $current_char = '';
      next;
    }
    $current_char .= $char;
    if ($char eq '[') {
      ++$level;
    } elsif ($char eq ']') {
      --$level;
    }
  }
  push @res, $current_char;
  return @res;
}

sub compare {
  my ($a, $b) = @_;
  return 0 if !$a && !$b;
  if  ($a =~ qr/^[0-9]+$/ && $b =~ qr/^[0-9]+$/) {
    return -1 if $a < $b;
    return 0 if $a == $b;
    return 1;
  }

  if (length($a) && !length($b)) {
    return 1;
  }
  if (!length($a) && length($b)) {
    return -1;
  }

  if ($a =~ qr/^[0-9]+$/ && substr($b, 0, 1) eq '[' && substr($b, -1) eq ']' && my_split($b) == 1) {
    $b = substr $b, 1, length($b) - 2;
    return compare($a, $b);
  }

  if ($b =~ qr/^[0-9]+$/ && substr($a, 0, 1) eq '[' && substr($a, -1) eq ']' && my_split($a) == 1) {
    $a = substr $a, 1, length($a) - 2;
    return compare($a, $b);
  }
  $a = substr($a, 1, length($a) - 2) if substr($a, 0, 1) eq '[' && substr($a, -1) eq ']' && my_split($a) == 1;
  $b = substr($b, 1, length($b) - 2) if substr($b, 0, 1) eq '[' && substr($b, -1) eq ']' && my_split($b) == 1;
  my @a = my_split($a);
  my @b = my_split($b);
  while (@a && @b) {
    my $x = shift @a;
    my $y = shift @b;
    return compare($x, $y) if compare($x, $y);
  }
  return -1 if !@a && @b;
  return 1 if (@a && !@b);
  return 0;
}

my $res = 0;
push @inputs, '[[2]]';
push @inputs, '[[6]]';

@inputs = sort {compare($a, $b) } @inputs;

# say Dumper @inputs;
my ($p2) = grep({$inputs[$_] eq '[[2]]'} (0..$#inputs));
my ($p6) = grep({$inputs[$_] eq '[[6]]'} (0..$#inputs));
say "$p2 $p6";
say int($p2 + 1) * ($p6 + 1);