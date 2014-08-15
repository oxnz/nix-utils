#!/bin/bash
#count=0
#while [ $count -lt 10 ]
#do
#	echo $count
#	count=$(($count+1))
#done > tmp
#
#while read count
#do
#	echo -n $count
#	for ((i=0; i<$count; i++))
#	do
#		echo -n x
#	done
#	echo
#done < tmp
#
#unlink tmp
#unset count

all=""
while read line
do
#	if [ "$(echo $line | awk '{print $2}')" = "male" ]
	if [ "$(echo $line | awk '{print $2}')" = "male" ]
	then
		all="$all $line"
	fi
done < data
echo $all

all=""
THE_INPUT=$(ps ef)
while read line
do
	if [ "$(echo $line | awk '{print $2}')" = "pts/0" ]
	then
		all="$all $line"
	fi
done <<EOF
$THE_INPUT
EOF
echo $all
