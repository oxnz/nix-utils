#!/bin/bash

i=0;
while((1))
do
	echo "Hello $i"
	sleep 1
	(( i++ ))
	trap "echo Hello" INT
#	trap "bash $0 && kill $$" QUIT
done
echo haha
