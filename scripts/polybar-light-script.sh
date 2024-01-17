#!/usr/bin/bash

# Prints the backlight level for polybar module.

# >>> variables declaration!
readonly version='1.0.0'
readonly script="`basename "$0"`"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Prints the backlight level for polybar module.

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
while :; do
	BACKLIGHT="$(brightnessctl get -d `brightnessctl -l | sed -nE "s/^Device '(.*)' .*backlight.*$/\1/p"`)"
	echo "☀️ $(bc <<< "$BACKLIGHT/10")%"
	sleep .1
done
