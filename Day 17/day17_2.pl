use v5.30;
use Data::Dumper;
use File::Slurp;

my $directions = read_file('day17.txt');
my @moves = split '', $directions;
my @pieces = (
  [[0, 0], [0, 1], [0, 2], [0, 3]],
  [[0, 0], [0, 1], [-1, 1], [1, 1], [0, 2]],
  [[0, 0], [0, 1], [0, 2], [1, 2], [2, 2]],
  [[0, 0], [1, 0], [2, 0], [3, 0]],
  [[0, 0], [0, 1], [1, 0], [1, 1]]
);

my %map;
my $max_height = -1;

sub is_inside {
  my ($idx, $cy) = @_;
  for my $block (@{$pieces[$idx]}) {
    return 0 if  $cy + $block->[1] >= 7;
  }
  return 1;
}

sub is_blocked {
  my ($idx, $cx, $cy) = @_;
  return 1 if $cx < 0;
  for my $block (@{$pieces[$idx]}) {
    my ($nx, $ny) = ($cx + $block->[0], $cy + $block->[1]);
    return 1 if $map{"$nx|$ny"};
  }
  return 0;
}

sub place {
  my ($idx, $cx, $cy) = @_;
  for my $block (@{$pieces[$idx]}) {
    my ($nx, $ny) = ($cx + $block->[0], $cy + $block->[1]);
    $map{"$nx|$ny"} = 1;
    $max_height = $nx if $max_height < $nx;
  }
  # for (my $i = $max_height; $i >= 0; --$i) {
  #   print "|";
  #   for my $j (0..6) {
  #     print '.' if !$map{"$i|$j"};
  #     print '#' if $map{"$i|$j"};
  #   }
  #   say "|";
  # }
  # say "---------";
  # say "$max_height\n";
}

my @heights;
for my $rock (0..202100) {
  my $current_piece = $rock % 5;
  my ($cx, $cy) = ($max_height + 4, 2);
  ++$cx if $current_piece == 1;
  while (1) {
    my $current_move = shift @moves;
    push @moves, $current_move;
    --$cy if $current_move eq '<' && $cy > 0 && !is_blocked($current_piece, $cx, $cy - 1);
    ++$cy if $current_move eq '>' && is_inside($current_piece, $cy + 1) && !is_blocked($current_piece, $cx, $cy + 1);

    # say "$current_move $cx $cy";
    
    if (is_blocked($current_piece, $cx - 1, $cy)) {
      place($current_piece, $cx, $cy);
      last;
    }
    --$cx;
  }
  push @heights, $max_height;
}

my @periods;
for my $i (1 .. $#heights) {
  push @periods, $heights[$i] - $heights[$i - 1];
}

my $period_sum = 0;
my $period_length;
for ($period_length = 1; $period_length <= 20000; ++$period_length) {
  my $ok = 1;
  $period_sum = 0;
  for my $i ($#periods - $period_length + 1 .. $#periods) {
    $period_sum += $periods[$i];
    for my $mul (1 .. 5) {
      if ($periods[$i] != $periods[$i - $period_length * $mul]) {
        $ok = 0;
        last;
      }
    }
  }
  if ($ok) {
    say $period_length;
    last;
  }
}

say $period_length;

my $target_pieces = 1000000000000;
my $total_pieces = 202100 + 1;

$max_height += int(($target_pieces - $total_pieces) / $period_length) * $period_sum;
for my $i (0 .. ($target_pieces - $total_pieces) % $period_length) {
  $max_height += $periods[$#periods - $period_length + 1 + $i];
}
say $max_height;