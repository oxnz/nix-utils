#!/bin/sh

stty -icanon min 0 time 30
echo "Input a letter or wait 3 seconds: "
x=$(read y)
echo $x
echo $y
x=$!
echo $x
