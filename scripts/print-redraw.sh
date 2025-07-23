#!/usr/bin/bash

# Sample tput example.

# >>> variables declaration!
readonly version='1.0.0'
readonly script="$(basename "$0")"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Sample tput example.

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
		h) usage; exit 1;;
		*) exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
redraw() {
	local width="$(tput cols)"
	local height="$(tput lines)"
	local message="width: $width - height: $height"
	local length="${#message}"
	clear
	tput cup "$((height/2))" "$(((width/2)-(length/2)))"
	echo -e "$message"
}
trap redraw WINCH
tput civis
#redraw; while :; do :; done
redraw; while :; do sleep .1; done
