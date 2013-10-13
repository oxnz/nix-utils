#!/bin/bash
# Detect online hosts in current LAN

NET="192.168.0"
COUNT=0
#for ip in $(seq 100 110)
# for base v3.x+ use following style
for ip in {100..110}
do
	ping -c 1 -W 1 ${NET}.${ip} &>/dev/null && result=0 || result=1
	if [ "$result" == 0 ]
	then
		echo "Host ${NET}.${ip} is UP."
		let COUNT=COUNT+1
	else
		:;
	#	echo "Host ${NET}.${ip} is DOWN"
	fi
done

printf "Host up [ %d ]\n" $COUNT
