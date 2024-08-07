#!/usr/bin/bash

# Returns the conversion of the passed argument to string, whether int, float, string, or file.

# >>> variables declaration!
readonly version='1.1.0'
readonly script="`basename "$0"`"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Returns the argument casting to a string.
	
Syntax:
	$script [<options>] <unique-argument>

Usage:
	$script "{some string|/path/to/file.txt|<integer>|<float>}"

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
ANY="${1:?need something to convert}"
[[ "$ANY" && -f "$ANY" ]] && cat "$ANY" || echo "$ANY"
