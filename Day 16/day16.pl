use v5.30;
use Data::Dumper;
use File::Slurp;

my (%rate, %neighbours);
my $max_flow = 0;

my @good_valves;

sub min_path {
  my ($source, $destination) = @_;
  my %dist;
  $dist{$source} = '0';
  my @q = ($source);
  while (@q) {
    my $fr = shift @q;
    for my $neighbour (@{$neighbours{$fr}}) {
      if (!$dist{$neighbour}) {
        $dist{$neighbour} = $dist{$fr} + 1;
        return $dist{$neighbour} if $neighbour eq $destination;
        push @q, $neighbour;
      }
    }
  }
}

my %used;
sub generate {
  my ($time, $current_flow, $last_node) = @_;
  return if $time > 30;

  $max_flow = $current_flow if $max_flow < $current_flow;

  for my $next_node (@good_valves) {
    if (!$used{$next_node}) {
      $used{$next_node} = 1;
      my $new_move_time = $time + min_path($last_node, $next_node) + 1;
      generate($new_move_time, $current_flow + (30 - $new_move_time) * $rate{$next_node}, $next_node);
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

for my $start_node (@good_valves) {
  $used{$start_node} = 1;
  my $starting_cost = min_path('AA', $start_node) + 1;
  generate($starting_cost, (30 - $starting_cost) * $rate{$start_node}, $start_node);
  delete $used{$start_node};
}

say $max_flow;