use Net::Ping;

use strict;
use warnings;

my $p = Net::Ping->new;

foreach(1..255) {
	my $ip = "192.168.1." . $_;
	print "$ip "; print "NOT " unless $p->ping($ip, 4);
	print "reachable.\n";
}
