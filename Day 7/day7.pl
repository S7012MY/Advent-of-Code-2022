use v5.30;
use Data::Dumper;

open in, 'day7.txt';

my @path = ();

my %folder_info;

while (chomp (my $line = <in>)) {
  my @command = split ' ', $line;
  if ($command[0] eq 'dir') {
    push @{$folder_info{$path[-1]}{'children'}}, $command[1];
  } elsif ($command[0] =~ qr/^[0-9]/) {
    my $path;
    for my $dir (@path) {
      $path .= $dir . '/';
      $folder_info{$path}{'size'} += $command[0];
    }
  } elsif ($command[1] eq 'cd' && $command[2] eq '..') {
    pop @path;
  } elsif ($command[1] eq 'cd' && $command[2] eq '/') {
    @path = ('/')
  } elsif ($command[1] eq 'cd') {
    push @path, $command[2];
  }
}

my $sum = 0;
for my $key (keys %folder_info) {
  $sum += $folder_info{$key}{'size'} if $folder_info{$key}{'size'} <= 100000;
}

say $sum;