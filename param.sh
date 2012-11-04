#   function Usage
function Usage
{
	echo "Usage:" 1>&2
	echo "    $0 Foo Bar [Option]" 1>&2
	echo "Option:" 1>&2
	echo "    Foo                       The input file." 1>&2
	echo "    Bar                       The output file." 1>&2
	echo "        --help                Display this message and exit." 1>&2
	echo "        --verbose             Verbose mode." 1>&2
	echo "        --work-dir [P]        The working directory." 1>&2
	echo "    -c, --config-file [F]     Set configure file." 1>&2
	echo "    -u, --unk                 Consider unknown words." 1>&2
	echo "    -d, --desc-str [S]        Set description string." 1>&2
	exit 1
}

#   parse argument
eval set -- "$(getopt -n $0 -o "c:ud:" -l "help,verbose,work-dir:,config-file:,unk,desc-str:" "--" "$@")"
if  [ $? -ne 0 ]
then
	Usage
fi
for o
do
	case "$o" in
		--help) Usage; shift;;
		--verbose) verbose=1; shift;;
		--work-dir) shift; work_dir="$1"; shift;;
		-c|--config-file) shift; config_file="$1"; shift;;
		-u|--unk) unk=1; shift;;
		-d|--desc-str) shift; desc_str="$1"; shift;;
		--) shift; break;;
	esac
done

#   rest paremeters
if [ $# -lt 2 ]
then
	Usage
fi
input_file="$1"
output_file="$2"
echo $input_file
echo $output_file
