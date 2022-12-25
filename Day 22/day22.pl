use v5.30;
use Data::Dumper;
use File::Slurp;
 
my @board = map { [split '', $_] } (split '\n', read_file('day22.txt'));
 
my $moves = join('', @{pop @board});
my @moves = ($moves =~ /([0-9]+|R|L)/g);
pop @board;
 
my $n = $#board;
my @m = map { scalar @{$board[$_]} } (0 .. $n);
 
my $start_col = (grep { $board[0][$_] eq '.' } (0 .. $m[0]))[0];
my $start_line = 0;
 
my @dx = (0, 1, 0, -1);
my @dy = (1, 0, -1, 0);
 
sub get_next_pos {
  my ($sx, $sy, $dir) = @_;
  my ($next_x, $next_y) = ($sx, $sy);
  do {
    $next_x = ($next_x + $dx[$dir] + $n) % $n;
    $next_y = $next_y + $dy[$dir];
    if ($dir % 2 == 0) {
      $next_y = ($next_y + $m[$next_x]) % $m[$next_x];
    }
  } while($board[$next_x][$next_y] eq ' ' || !$board[$next_x][$next_y]);
  return ($next_x, $next_y);
}
 
 
my $cdir = 0;
my %steps = ( R => 1, L => 3);
 
++$n;
for my $move (@moves) {
  # say $move;
  if ($move =~ /R|L/) {
    $cdir = ($cdir + $steps{$move}) % 4;
  } else {
    # say $move;
    # say "Start: $start_line $start_col";
    # say $cdir;
    for (1 .. $move) {
      my ($next_line, $next_col) = get_next_pos($start_line, $start_col, $cdir);
      # say "$next_line $next_col";
      last if ($board[$next_line][$next_col] eq '#');
      ($start_line, $start_col) = ($next_line, $next_col);
    }
  }
  # say "$start_line $start_col";
}
 
say "$start_line $start_col $cdir";
++$start_line; ++$start_col;
say 1000 * $start_line + 4 * $start_col + $cdir;