#!/usr/bin/bash

# Send Color To ClipBoard sends the hex code of the color to your clipboard.

# >>> variables declaration!
readonly version='1.1.0'
readonly script="`basename "$0"`"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Sends the hex code of the color to your clipboard.

Usage: $script [<options>]

Options:
	-v: Print version;
	-h: Print this help.
EOF
}

# >>> pre statements!
while getopts 'vh' option; do
	case "$option" in
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
colorpicker --one-shot --short | xclip -sel clip -rmlastnl
