#!/usr/bin/bash

# A simple clock in loop.

# >>> variable declaration!
readonly version='1.0.0'
script="`basename "$0"`"

# >>> function declaration!
usage() {
cat << EOF
$script v$version

Simple CLI clock that uses built-in date command.

Usage: $script [<option>]

Options:
	-v: Print version;
	-h: Print this help.
EOF
}

# >>> pre statements!
while getopts 'vh' OPTION; do
	case "$OPTION" in
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
while :; do
	echo -en "`date +%T`\r"
done
