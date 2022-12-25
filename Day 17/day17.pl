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

for my $rock (0..2021) {
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
  say $max_height;
}

say $max_height + 1;