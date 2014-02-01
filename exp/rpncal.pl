#!/usr/bin/env perl

use warnings;
use strict;

my @stack;
my $actions = {
#	'+' => sub { push @stack, pop(@stack) + pop(@stack) },
#	'*' => sub { push @stack, pop(@stack) * pop(@stack) },
#	'-' => sub { push @stack, - (pop(@stack) - pop(@stack)) },
#	'/' => sub { $stack[-2] /= $stack[-1]; pop @stack },
#	'sqrt' => sub { push @stack, sqrt(pop(@stack)) },
	'NUMBER' => sub { push @stack, $_[0] },
	'_DEFAULT_' => sub { my $x = pop(@stack); push @stack,
		[ $_[0], pop(@stack), $x ] },
};

my $result = evaluate($ARGV[0], $actions);
print "Result: ", $result, "\n";

sub AST_to_string {
	my ($tree) = @_;
	if (ref $tree) {
		my ($op, $a, $b) = @$tree;
		my ($s1, $s2) = (AST_to_string($a), AST_to_string($b));
		"($s1 $op $s2)";
	} else {
		$tree;
	}
}

sub evaluate {
	my ($expr, $actions) = @_;
	my @tokens = split /\s+/, $expr;
	
	foreach (@tokens) {
		my $type;
		if (/^\d+$/) { # It's a number
			$type = 'NUMBER';
		}
		my $action = $actions->{$type || $_} || $actions->{_DEFAULT_};
		$action->($_, $type, $actions);
	}
	return eval AST_to_string(@stack);
	#print AST_to_string(@stack), "\n";
	#return pop(@stack);
}
