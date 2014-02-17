#!/usr/bin/awk -f

function help(hformat) {
	if (hformat == 0)
		printf "Usage: %s [option] [file]", ARGV[0]
	else
	{
		printf "Usage: %s [option] [file]", ARGV[0]
		printf "END\n"
	}
	tformat = "%A %B %C"
	print systime()
}

function prepare() {
	sub(/^[\t]+/, "")	# delete the pre blanks
	sub(/[\t]+$/, "")	# delete the after blanks
}

function indent() {
	sub(/\\subsection/, "\t&")
	sub(/\\subsubsection/, "\t\t&")
	sub(/\\subsubsubsection/, "\t\t\t&")
}

function output() {
	print $0
}

BEGIN {
	if (ARGC != 2)
		help(0)
}

prepare()
indent()
output()

END {
}
