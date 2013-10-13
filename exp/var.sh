#!/bin/bash

echo '$#='$#
echo '$@='$@
echo '$*='$*

shopt -s -o nounset

declare -f usage
usage()
{
	echo "Usage: $0 {a|b|cd}"
	echo $FUNCNAME
	echo $1 $2
}
usage b c
unset -f usage

while getopts u:ah opt
do
	case $opt in
		u)
			echo u:$OPTARG;;
		a)
			echo a;;
		h)
			echo h;;
		*);;
	esac
done
