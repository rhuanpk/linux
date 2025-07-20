#!/usr/bin/bash

# A simple counter that increments.

# >>> variables declaration!
readonly version='1.2.0'
readonly script="`basename "$0"`"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Simple and intelligent counter.
Counting 1 by 1 pressioning ENTER or pass negative value to decrease (-<value>).

Usage: $script [<options>]

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
declare -i answer
while :; do
	clear
	echo ">>> COUNT = ${COUNT:-<nothing yet>}!"
	read -p 'Input [1]: ' answer
	[ "$answer" -eq 0 ] && let ++COUNT || let COUNT+=answer
done
