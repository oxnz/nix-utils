#!/usr/bin/env perl

use strict;
use warnings;

my @vmstat = $(vm_stat);
my ($pagesz) = scalar(shift @vmstat) =~ /(\d+)/;
my %meminfo = map {
	chomp;
	my ($k, $v) = split /\s{2,}/;
	$k => hsz($pagesz * int($v))
} @vmstat;

foreach (sort keys %meminfo) {
	print $_, ' ' x (40 - length), $meminfo{$_}, "\n";
}

# human-readable size
sub hsz{
	my $size = shift;
	my @suffix = qw/B KB MB GB TB PB/;
	my $i = 0;
	++$i and $size /= 1024 while ($size >= 1024);
	return sprintf("%-8.2f %s", $size, $suffix[$i]);
}
