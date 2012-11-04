#!/bin/bash

whatami=`basename $0`

case $whatami in
	greet)
		echo Hello!;;
	bye)
		echo Bye-Bye;;
	*)
cat <<EOD
Usage: "$0 [greet|bye]"
EOD
		;;
esac
