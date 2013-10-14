#!/bin/bash
# Author: Oxnz

# using awk
#find . -print | awk -F "/" '{for (i=1; i<=NF-2; i++){printf "| "} print "|________"$NF}'

# using sed
find . -print | sed -e 's;[^/]*/;|_______;g;s;_______|; |;g'
