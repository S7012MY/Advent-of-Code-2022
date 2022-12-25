use v5.30;
use Data::Dumper;
use File::Slurp;

my (%rate, %neighbours);
my $max_flow = 0;

my @good_valves;

my %memo_path;
sub min_path {
  my ($source, $destination) = @_;
  return $memo_path{"$source|$destination"} if $memo_path{"$source|$destination"};
  my %dist;
  $dist{$source} = '0';
  my @q = ($source);
  while (@q) {
    my $fr = shift @q;
    for my $neighbour (@{$neighbours{$fr}}) {
      if (!$dist{$neighbour}) {
        $dist{$neighbour} = $dist{$fr} + 1;
        if ($neighbour eq $destination) {
          $memo_path{"$source|$destination"} = $memo_path{"$destination|$source"} = $dist{$neighbour};
          return $dist{$neighbour};
        }
        push @q, $neighbour;
      }
    }
  }
}

my @all_valves;
my %used;
sub generate {
  my ($time, $current_flow, $last_node) = @_;
  return if $time > 26;
  return if keys %used == @all_valves;

  $max_flow = $current_flow if $max_flow < $current_flow;

  for my $next_node (@all_valves) {
    if (!$used{$next_node}) {
      $used{$next_node} = 1;
      my $new_move_time = $time + min_path($last_node, $next_node) + 1;
      generate($new_move_time, $current_flow + (26 - $new_move_time) * $rate{$next_node}, $next_node);
      delete $used{$next_node};
    }
  }
}

for my $line (split '\n', read_file('day16.txt')) {
  $line =~ qr/Valve ([a-zA-Z]{2}) has flow rate=([0-9]+); tunnels? leads? to valves? (.+)/;
  my ($source, $rate, $neighbours) = ($1, $2, $3);
  $rate{$source} = $rate;
  push @good_valves, $source if $rate;
  $neighbours{$source} = [split ', ', $neighbours];
}

my @best_cost;
for my $s (1 .. (1 << 15) - 1) {
  say $s;
  for my $i (0..$#good_valves) {
    push @all_valves, $good_valves[$i] if $s & (1 << $i);
  }
  say join ',', @all_valves;
  for my $start_node (@all_valves) {
    $used{$start_node} = 1;
    my $starting_cost = min_path('AA', $start_node) + 1;
    generate($starting_cost, (26 - $starting_cost) * $rate{$start_node}, $start_node);
    delete $used{$start_node};
  }
  $best_cost[$s] = $max_flow;
  say $best_cost[$s];
  @all_valves = ();
  $max_flow = 0;
}


for my $s (1 .. (1 << 15) - 1) {
  $max_flow = $best_cost[$s] + $best_cost[((1 << 15) - 1) ^ $s] if $max_flow < $best_cost[$s] + $best_cost[((1 << 15) - 1) ^ $s];
}
say $max_flow;