#!/bin/bash

USERNAME=$(whoami)
USERID=$(id -u)

help()
{
	echo This is the help msg
	exit 0
}

while read opt
do
	case $opt in
		"status")
			echo status:...
			;;
		"config")
			select c in "Apache" "Mysql" "Tomcat"
			do
				echo your choice: $c
				break;
			done
			;;
		"help")
			help
			;;
		"quit")
			echo bye-bye
			exit 0
			;;
		*)
			echo Unkonwn option, try again:
			;;
	esac
done
