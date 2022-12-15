use v5.30;
use Data::Dumper;

open in, 'day7.txt';

my @path = ();

my %folder_info;

while (chomp (my $line = <in>)) {
  my @command = split ' ', $line;
  if ($command[0] eq 'dir') {
  } elsif ($command[0] =~ qr/^[0-9]/) {
    my $path;
    for my $dir (@path) {
      $path .= $dir . '/';
      $folder_info{$path} += $command[0];
    }
  } elsif ($command[1] eq 'cd' && $command[2] eq '..') {
    pop @path;
  } elsif ($command[1] eq 'cd' && $command[2] eq '/') {
    @path = ('/')
  } elsif ($command[1] eq 'cd') {
    push @path, $command[2];
  }
}

my $required_space = 30000000 - 70000000 + $folder_info{'//'};

my $min_size = 70000000;
for my $key (keys %folder_info) {
  if ($folder_info{$key} >= $required_space && $min_size > $folder_info{$key}) {
    $min_size = $folder_info{$key};
  }
}

say $min_size;