#!/bin/bash

	return 2121
x=/usr/bin/lib

echo ${x=##}

ATH=$PATH
pathmunge()
{
	case ":${ATH}:" in
		*:"$1":*)
			;;
		*)
			if [ "$2" = "after" ]
			then
				ATH=$ATH:$1
			else
				ATH=$1:$ATH
			fi
			;;
	esac
}

pathmunge /home/a2di/bin after
pathmunge /usr/lib/java/jdk1.7.0_07/bin after
echo $ATH
