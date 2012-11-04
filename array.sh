#!/bin/bash

x=""
if [ -n $x ]
then
	echo x exist
else
	echo x non-exist
fi
unset x

host=www.google.com
if ping -c 1 -w 1 $host > /dev/null 2>&1
then
	echo $host is alive
else
	echo $host is offline
fi

declare -a array
array=`ls`
array=([0]=zerooo [5]=five [2]=two)

for i in ${array[@]}
do
	echo $i
done

:<<BLOCK
Hello, this is the commented content
this is the second line.
the very last line
BLOCK

cat<<Menu
1.list
2.delete
3.CRLF
Menu

for ((i=0;i<${#array[@]};i++))
do
	echo ${array[$i]}
done

printf "#array:"
echo ${#array}
printf "#array[@]:"
echo ${#array[@]}
echo ${#array[0]}
expr length ${array[0]}
echo -n ${array[0]} | wc -c
echo -n ${array[0]} | awk '{print length($0)}'

:||:<<\COMMENTS
world
comment
Helo
COMMENTS

echo "$!"
