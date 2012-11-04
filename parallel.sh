#!/bin/bash


thevar="one two three four five six"
pipe="./tmpipe"

some_function() {
	all=$*
	for i in $all
	do
		set -m
		echo $i > $pipe &
		wait
		set +m
	done
}

some_function $thevar &
for i in 1 2 3 4 5 6
do
	read read_var < $pipe
	echo The read_var is $read_var
	sleep .005s
done
