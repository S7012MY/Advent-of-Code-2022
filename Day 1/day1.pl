use v5.30;
use Data::Dumper;
use File::Slurp;
use List::Util qw(max sum);

my $file_content = read_file('day1.txt');
my @data = split '\n\n', $file_content;
say max (map {sum (split '\n', $_)} @data);