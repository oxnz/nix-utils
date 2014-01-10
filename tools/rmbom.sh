#!/usr/bin/sh

function rmbom() {
	if [ $# -lt 1 ]; then
		printf "Usage: rmbom [bomfile]\n"
		return 1
	fi
	if [ ! -f $1 ]; then
		echo "$1 not exist"
		return 1
	fi
	# Need to be at root
	cd /
	lsbom -fls $1 | xargs -I{} rm -r "{}"
	rm -f $1
	return 0
}

rmbom $@
