#!/bin/bash

wan="192.168.0"
totalup=0
totaldown=0
for ip in $(seq 1 100)
do
	ping -c 1 -w 1 ${wan}.${ip} &>/dev/null && result=0 || result=1
	if [ "$result" == 0 ]
	then
		echo "PC ${wan}.${ip} is UP."
		totalup=$((${totalup}+1))
	else
		echo "PC ${wan}.${ip} is DOWN"
		totalup=$((${totaldown}+1))
	fi
done
printf "PC up [ %d ] down [ %d ]" totalup totaldown
