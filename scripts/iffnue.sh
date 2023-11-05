#!/usr/bin/bash

# Errnue validate if you want to continue or no and respectively returns true or false.

# >>> variable declaration!
readonly version='1.0.0'
script="`basename "$0"`"

# >>> function declaration!
usage() {
cat << EOF
$script v$version

Return 0 for 'y' or 'Y' and 1 for default (any other values) value.
For custom message pass your prhase like arguments.

Usage: $script [<options>] ['any number'] ['of'] ['messages']

Options:
	-a: Auto mode: return in the firts char inputted;
	-v: Print version;
	-h: Print this help.
EOF
}

# >>> pre statements!
while getopts 'avh' OPTION; do
	case "$OPTION" in
		a) ARGS+=' -n 1';;
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
message="${*:-continue? [y/N] }"
read $ARGS -ep "$message" answer
[ -z "$answer" ] || [ y != "${answer,,}" ] && exit 1 || exit 0
