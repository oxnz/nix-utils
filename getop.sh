#!/bin/bash

ARGV=($(getopt -o a:b:c -l aaa,bbb,ccc -- "$@"))
eval set -- "$ARGV"

while true
do
	case "$1" in
		-a|--aaa)
			echo "A"
			shift
			break;
			;;
		-b|--bbb)
			echo "B"
			shift 2
			break;
			;;
		-c|--ccc)
			echo "C"
			shift 3
			;;
		*)
			echo "Unknown option"
			exit 1
	esac
done
