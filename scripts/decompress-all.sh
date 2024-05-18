#!/usr/bin/bash

# This script decompress most popular compress extensions.
# Create a folder with same name of the file then decompress inside her.

# >>> variables declaration!
readonly version='1.3.1'
readonly script="`basename "$0"`"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Decompress all most popular compacting extension of the files in current directory:
	- .zip
	- .xz
	- .gz
	- .tar.gz
	- .tar.xz
	- .tar
	- .tbz2
	- .tar.bz2

This works creating a folder with the name of file and move myself to it.

Usage: $script [<options>]

Options:
	-p <path>: Specifies the path where compressed files are located;
	-v: Print version;
	-h: Print this help.
EOF
}

action() {
	COMMAND="${1:?need a command to execute}"
	mkdir "./$FOLDER/"
	mv "./$file" "./$FOLDER/"
	cd "./$FOLDER/"
	eval $COMMAND "'./$file'"
	cd ../
}

# >>> pre statements!
while getopts 'p:vh' OPTION; do
	case "$OPTION" in
		p) PATHWAY="`realpath $OPTARG`";;
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
[ -n "$PATHWAY" ] && {
	[ ! -d "$PATHWAY" ] && { echo -e "$script: error: folder \"$PATHWAY\" not found"; exit 1; } \
	|| if ! OUTPUT=`cd "$PATHWAY" 2>&1`; then
		{
			[[ "$OUTPUT" =~ [nN]ot\ a\ directory ]] \
			&& echo -e "\n$script: error: \"$PATHWAY\" is not a folder"
		} || {
			[[ "$OUTPUT" =~ [pP]ermission\ denied ]] \
			&& echo -e "\n$script: error: \"$PATHWAY\" don't has permission";
		} || \
			echo -e "\n$script: error: some wrong occurred on entering in \"$PATHWAY\""
		exit 1
	fi
}
for file in *; do
	#EXTENSION=`grep -oE '\.[^[:digit:]]+$' <<< "$file"`
	EXTENSION=".${file##*.}"
	: EXTENSION="${EXTENSION:-noextension}"
	#FOLDER=`cut -d '.' -f 1 <<< "$file"`
	FOLDER="${file%.*}"

	if [[ "$EXTENSION" =~ ^\.(tar|tbz2)(.(xz|bz2))?$ ]]; then
		action 'tar -xvf'
	else
		case "$EXTENSION" in
			'.tar.gz') action 'tar -zxvf';;
			'.zip') action 'unzip';;
			'.xz') action 'xz -kdv';;
			'.gz') action 'gzip -kdv';;
			'.rar') action 'unrar x';;
			#*) 7z x "./$file" >&-;;
			#'noextension') echo -e "\n$script: warn: file \"$file\" has no extension or is not recognized"
			*) echo -e "\n$script: warn: file \"$file\" has no extension or is not recognized"
		esac
	fi
done
