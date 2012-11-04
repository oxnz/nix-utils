#!/bin/bash

function getchoice() {
	WORD="a s d h"
	select i in $WORD
	do
		case $i in
			a)
				i='a'
				break;
				;;
			s)
				i='s'
				break;
				;;
			d)
				i='d'
				break;
				;;
			h)
				i='h'
				break;
				;;
			*)
				echo "Unknow option, try again:"
				;;
		esac
	done
	eval ${1}=$i
}

if [ $# -ne 1 ]
then
	echo "In if"
	getchoice a
	echo \$a=${a}
	set "${i}"
fi

case $1 in
	a)
		echo "A"
		;;
	b)
		echo "B"
		;;
	c)
		echo "C"
		;;
esac
