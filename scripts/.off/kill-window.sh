#!/usr/bin/bash

# Launch a selector for you select a specific window to kill.

# >>> variables declaration!
readonly version='1.0.0'
readonly script="`basename "$0"`"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Short description of how it works.

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
xdotool selectwindow windowkill
