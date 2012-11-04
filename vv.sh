#!/bin/bash

abc=1234
: ${abc:="123"}
echo $abc
unset abc

username=""
echo "${username:=$LOGNAME}"
echo $username
unset username
username=""
echo "${username=$LOGNAME}"
