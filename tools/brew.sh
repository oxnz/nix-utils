#!/bin/sh
# Copyright (C) 2013 Oxnz, All rights reserved.


URL='https://raw.github.com/Homebrew/homebrew/master/Library/Formula/'

function show() {
	curl ${URL}${1}.rb
}

function list() {
	echo "Unimplemented yet"
}

function usage() {
cat << EOH
Usage: <option> [name]
  options:
	show	show instructions to install package specified by name
	list	list available packages
EOH
}

function main() {
	case "$1" in
		"" | -h | --help)
			usage
			exit 0
			;;
		-s | --show | show)
			if [ $# -lt 2 ]; then
				echo "please specified a name to show"
				exit 1
			else
				shift
				while [ $# -ge 1 ]; do
					show "$1"
					shift
				done
			fi
			;;
		-l | --list | list)
			if [ $# -ne 1 ]; then
				echo "Usage: $0 list"
				exit 1
			else
				list
			fi
			;;
		*)
			echo "*** error: unrecognized parameter: [$@]"
			exit 1
			;;
	esac
}

main $@
