#!/usr/bin/env perl

use strict;
use warnings;

my @vmstat = `vm_stat`;
my %meminfo = (
	'Page size' => scalar(shift @vmstat) =~ /(\d+)/,
);

foreach (@vmstat) {
	chomp;
	my ($k, $v) = split /\s{2,}/;
	$meminfo{$k} = int($v);
}

foreach (sort keys %meminfo) {
	print $_,
	' ' x (40 - length),
	hsz($meminfo{$_} * $meminfo{'Page size'}), "\n";
}

# human-readable size
sub hsz{
	my $size = shift;
	my @suffix = qw/B KB MB GB TB PB/;
	my $i = 0;
	++$i and $size /= 1024 while ($size >= 1024);
	return sprintf("%-8.2f %s", $size, $suffix[$i]);
}
