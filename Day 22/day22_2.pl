use v5.30;
use Data::Dumper;
use File::Slurp;
 
my @board = map { [split '', $_] } (split '\n', read_file('day22.txt'));
 
my $moves = join('', @{pop @board});
my @moves = ($moves =~ /([0-9]+|R|L)/g);
pop @board;
 
my $n = @board / 4;
say $n;
 
my $start_col = (grep { $board[0][$_] eq '.' } (0 .. 3 * $n - 1))[0];
my $start_line = 0;
 
my $dir = 0;
my @dx = (0, 1, 0, -1);
my @dy = (1, 0, -1, 0);
 
sub get_next_pos {
  my ($sx, $sy) = @_;
  my ($next_x, $next_y) = ($sx + $dx[$dir], $sy + $dy[$dir]);
  return ($next_x, $next_y) if 0 <= $next_x && $next_x < 4 * $n && 0 <= $next_y && $next_y < 3 * $n && $board[$next_x][$next_y] =~ qr/[#|\.]/;
  # Face 1
  if (0 <= $sx && $sx < $n && $n <= $sy && $sy < 2 * $n) {
    if ($dir == 2) {
      $dir = 0;
      return ($n - $sx - 1 + 2 * $n, 0);
    }
    if ($dir == 3) {
      $dir = 0;
      return (2 * $n + $sy, 0);
    }
    say "Problem 1";
  }

  # Face 2
  if (0 <= $sx && $sx < $n && 2 * $n <= $sy && $sy < 3 * $n) {
    if ($dir == 3) {
      return (4 * $n - 1, $sy - 2 * $n);
    }
    if ($dir == 0) {
      $dir = 2;
      return ($n - $sx - 1 + 2 * $n, 2 * $n - 1);
    }
    if ($dir == 1) {
      $dir = 2;
      return ($sy - $n, 2 * $n - 1);
    }
    say "Problem 2";
  }

  # Face 3
  if ($n <= $sx && $sx < 2 * $n && $n <= $sy && $sy < 2 * $n) {
    if ($dir == 2) {
      $dir = 1;
      return (2 * $n, $sx - $n);
    }
    if ($dir == 0) {
      $dir = 3;
      return ($n - 1, $sx + $n);
    }
    say "Problem 3";
  }
  
  # Face 4
  if (2 * $n <= $sx && $sx < 3 * $n && 0 <= $sy && $sy < $n) {
    if ($dir == 2) {
      $dir = 0;
      return ($n - ($sx - 2 * $n) - 1, $n);
    }
    if ($dir == 3) {
      $dir = 0;
      return ($sy + $n, $n);
    }
    say "Problem 4";
  }

  # Face 5
  if (2 * $n <= $sx && $sx < 3 * $n && $n <= $sy && $sy < 2 * $n) {
    if ($dir == 0) {
      $dir = 2;
      return ($n - ($sx - 2 * $n) - 1, 3 * $n - 1);
    }
    if ($dir == 1) {
      $dir = 2;
      return ($sy + 2 * $n, $n - 1);
    }
    say "Problem 5";
  }
  # Face 6
  if (3 * $n <= $sx && $sx < 4 * $n && 0 <= $sy && $sy < $n) {
    if ($dir == 2) {
      $dir = 1;
      return (0, $sx - 2 * $n);
    }
    if ($dir == 0) {
      $dir = 3;
      return (3 * $n - 1, $sx - 2 * $n);
    }
    if ($dir == 1) {
      return (0, $sy + 2 * $n);
    }
    say "Problem 6";
  }
  say "ERROR";
  exit;
  $next_x = -1;
  return ($next_x, $next_y);
}

# my ($x, $y) = get_next_pos($start_line + 50, $start_col, 3);
# say "$x $y";

my %steps = ( R => 1, L => 3);
 
for my $move (@moves) {
  # say $move;
  if ($move =~ /R|L/) {
    $dir = ($dir + $steps{$move}) % 4;
  } else {
    # say $move;
    # say "Start: $start_line $start_col";
    # say $dir;
    for (1 .. $move) {
      my  $cdir = $dir;
      my ($next_line, $next_col) = get_next_pos($start_line, $start_col, $dir);
      exit if ($next_line < 0 || $next_col < 0);
      # say "$next_line $next_col";
      if ($board[$next_line][$next_col] eq '#') {
        $dir = $cdir;
        last;
      }
      ($start_line, $start_col) = ($next_line, $next_col);
    }
  }
  # say "$start_line $start_col";
}
 
say "$start_line $start_col $dir";
++$start_line; ++$start_col;
say 1000 * $start_line + 4 * $start_col + $dir;