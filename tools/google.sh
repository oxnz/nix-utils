#!/usr/bin/sh


function google() {
	local url="https://www.google.com.hk/search?hl=en#newwindow=1&q="
	case "$1" in
		"" | -h | --help)
			cat << EOH
google:
	google "keyword" to search
EOH
			exit 0
			;;
		*)
			while [ $# -ge 1 ]; do
				#echo "$url${1// /+}"
				open "$url${1// /+}"
				shift
			done
			;;
	esac
}

google "$@"
