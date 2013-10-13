#!/usr/bin/perl
#
use strict;
use warnings;
use Data::Dumper;
use Net::FTP;
use Getopt::Long;

my %opts;
my $ftp;

# Get user specifications and operations
BEGIN {
	%opts = (
		'host'	=> 'ftp.gnu.org',
		'port'	=> 21,
		'debug'	=> 0,
		'user'	=> 'anonymous',
		'pass'	=> '',
		'timeout'	=> 60,
		'rdir'	=> '/gnu',
	);

	GetOptions(\%opts, 'host', 'port', 'debug', 'user=s', 'pass=s', 'rdir=s',
		'timeout', 'list!', 'get=s@{1,}',
	) or die("Error: $!\n");
}

sub list() {
	my $pwd = $ftp->pwd();
	print "Current working directory=> [$pwd]\n";
#	print "Software List:\n";
	my @softwares = $ftp->ls($pwd);
	for (@softwares) {
		print substr($_, length($opts{rdir})+1),"\n";
	}
}

sub get() {
	my $name = shift;
	print "Getting=> [$name]\n";
	for ($ftp->ls($name)) {
		print substr($_, length($name)+1), "\n";
	}
	$ftp->get($name, $name) or die("Couldn't get=> [$name]: ",
		$ftp->message);
#	$ftp->get($remote, $local, $offset);
}

# Init ftp connection
INIT {
#	print "Initialization...\n";
	my $h = \%opts;
	print Dumper($h);
	$ftp = Net::FTP->new(
		Host=>$h->{host},
		Port=>$h->{port},
		Debug=>$h->{debug},
		Timeout=>$h->{timeout}
	) or die("Cannot connect to =>[$h->{host}] : $@\n");
	
#	print "Connected to server=> [$h->{host}]\n";
	$ftp->login($h->{user}, $h->{pass}) or die("Couldn't login: ",
		$ftp->message);
#	print "Logged in as [$h->{user}]\n";
	$ftp->cwd($h->{rdir}) or die(
		"Cannot change working directory to [$h->{rdir}]: ", $ftp->message);
	if ( exists $h->{list} ) {
		&list();
	} elsif ( exists $h->{get} ) {
		my $lref = $h->{get};
		for (@{$lref}) {
#			print "Getting => [$_] ...\n";
			&get($_);
		}
	}
}

END {
	$ftp->quit();
#	print "Bye\n";
}
