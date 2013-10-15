#!/bin/sh


URL='https://raw.github.com/mxcl/homebrew/master/Library/Formula/'

function show() {
	curl ${URL}${1}.rb
}

function main() {
	if [ $# -le 1 ]; then
		echo "Usage: <option> [name]"
		exit 1
	fi

	case $1 in
		show)
			if [ $# -ne 2 ]; then
				echo "Usage: $0 show <name>"
				exit 1
			else
				show "$2"
			fi
			;;
		list)
			if [ $# -ne 1 ]; then
				echo "Usage: $0 list"
				exit 1
			fi
			;;
		*)
			echo "*** error: parameter(s) error"
			exit 1
			;;
	esac
}

main $@
