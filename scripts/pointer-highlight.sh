#!/usr/bin/bash

# Start or kill the highlight-pointer.

# >>> variables declaration!
readonly version='1.1.0'
readonly script="`basename "$0"`"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Start or kill the highlight-pointer.

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
if ! ps -C highlight-pointer &>/dev/null; then
	highlight-pointer \
		--show-cursor \
		-o 3 \
		-r 27.5 \
		-c '#303030' \
		-p '#a41313' \
		-t 1 \
		--auto-hide-cursor \
		--auto-hide-highlight
else
	killall highlight-pointer
fi
