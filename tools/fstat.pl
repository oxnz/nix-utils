#!/usr/bin/env perl

use strict;
use warnings;

sub filestat {
	my %fstat;
	my @statnames = qw/dev inode mode nlink uid gid rdev size atime mtime
	ctime blksize blocks/;
	@fstat{@statnames} = stat;
	$fstat{'file'} = $_;
	$fstat{'uid'} .= "(" . scalar(getpwuid($fstat{'uid'})) . ")";
	$fstat{'gid'} .= "(" . scalar(getgrgid($fstat{'gid'})) . ")";
	foreach ("file", @statnames) {
		$fstat{$_} = localtime $fstat{$_} if /time$/;
		print $_, " " x (10 - length), $fstat{$_}, "\n";
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
