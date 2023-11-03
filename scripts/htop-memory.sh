#!/usr/bin/bash

# Take the consumption of ram memory.

# >>> variable declaration!
readonly version='1.0.0'
script="`basename "$0"`"

# >>> function declaration!
usage() {
cat << EOF
$script v$version

Take the consumption of ram memory

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
echo "RAM: $(($(free -m | tr -s ' ' | head -n 2 | tail -n 1 | cut -d ' ' -f 3)+100)) MB"
