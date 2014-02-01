#!/usr/bin/env perl

use strict;
use warnings;

sub filestat {
	my %fstat;
	my @statnames = qw/dev ino mode nlink uid gid rdev size atime mtime
	ctime blksize blocks/;
	@fstat{@statnames} = stat;
	print "file:\t$_\n";
	foreach (@statnames) {
		$fstat{$_} = localtime $fstat{$_} if /time$/;
		print $_, ":\t", $fstat{$_}, "\n";
	}
}

sub main {
	foreach (@ARGV) {
		if (-e) {
			filestat;
		} else {
			print "not a valid file: $_\n";
		}
	}
}

main @ARGV
