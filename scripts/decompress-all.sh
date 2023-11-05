#!/usr/bin/bash

# This script decompress most popular compress extensions.
# Create a folder with same name of the file then decompress inside her.

# >>> variable declaration!
readonly version='1.2.1'
script="`basename "$0"`"

# >>> function declaration!
usage() {
cat << EOF
$script v$version

Decompress all most popular compacting extension:
	- .zip
	- .xz
	- .gz
	- .tar.gz
	- .tar.xz
	- .tar
	- .tbz2
	- .tar.bz2

And try to decompress another compression types with \`7z\` command.
This works create a folder with the name of file and move myself to it.

NOTE: Have all compressed files in a separete folder.

Usage: $script [<options>]

Options:
	-p <path>: Specifies the path where compressed files are located;
	-v: Print version;
	-h: Print this help.
EOF
}

# >>> pre statements!
while getopts 'p:vh' OPTION; do
	case "$OPTION" in
		p) PATHWAY="$OPTARG";;
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
[ -n "$PATHWAY" ] && [ ! -d "$PATHWAY" ] && echo -e "$script: folder \"$PATHWAY\" not found"
for file in `ls -1 $PATHWAY`; do
	EXTENSION=`grep -oE '(\.[^[:digit:]]*.*)$' <<< "$file"`
	FOLDER=`cut -d '.' -f 1 <<< "$file"`

	mkdir "./$FOLDER/"
	mv "./$file" "./$FOLDER/"
	cd "./$FOLDER/"

	if [[ "$EXTENSION" =~ ^\.(tar|tbz2)(.(xz|bz2))?$ ]]; then
		tar -xvf "./$file"
	else
		case "$EXTENSION" in
			'.tar.gz') tar -zxvf "./$file";;
			'.zip') unzip "./$file";;
			'.xz') xz -kdv "./$file";;
			'.gz') gzip -kdv "./$file";;
			*) 7z x "./$file";;
		esac
	fi

	cd ../
done
