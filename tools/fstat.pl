#!/usr/bin/env perl

use strict;
use warnings;
use POSIX qw/strftime/;

sub filestat {
	my %fstat;
	my @statnames = qw/dev inode mode nlink uid gid rdev size atime mtime
	ctime blksize blocks/;
	@fstat{@statnames} = stat;
	$fstat{'file'} = $_;
	$fstat{'uid'} .= "(" . scalar(getpwuid($fstat{'uid'})) . ")";
	$fstat{'gid'} .= "(" . scalar(getgrgid($fstat{'gid'})) . ")";
	foreach ("file", @statnames) {
		$fstat{$_} = strftime "%T %F %Z", localtime $fstat{$_} if /^[amc]time$/;
		print $_, " " x (10 - length), $fstat{$_}, "\n";
	}
}

sub main {
	foreach (@ARGV) {
		if (-e) {
			filestat;
		} elsif (/^-{1,2}\w/) {
			if (/-h|--help/) {
				print <<EOH;
Usage: $0 [option] <files>
  options:
    -h  --help    show this help message and exit
    -v  --version show version info and exit
EOH
				exit
			} elsif (/-v|--version/) {
				print <<EOV;
$0 version 0.1, authorized by oxnz
EOV
				exit
			} else {
				print "*** error: unrecognized option: $_\n";
				exit 1
			}
		} else {
			print "*** error: not a valid file: $_, skipped\n";
		}
	}
}

main @ARGV
