#!/usr/bin/bash

# Brightness control.

# >>> variable declaration!
readonly version='1.0.0'
script="`basename "$0"`"

# >>> function declaration!
usage() {
cat << EOF
$script v$version

Change brightness value.

Usage: $script [<options>]

Options:
	-v: Print version;
	-h: Print this help.
EOF
}

pick-display() {
	brightnessctl -l | sed -nE "s/^Device '(.*)' .*backlight.*$/\1/p"
}

get-brighteness-percent() {
	brightnessctl get -d `pick-display`
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
# nohup terminator --borderless --geometry='250x30' --command='bc' &
while :; do
	clear
	echo -n "Br1ghtn355 $(get-brighteness-percent)0% [+/-]? "; read -n 1 VALUE
	if [ "${VALUE,,}" = "q" ]; then
		exit 0
	elif [ "${VALUE}" = "+" ]; then
		brightnessctl --quiet -d $(pick-display) set +5%
	elif [ "${VALUE}" = "-" ]; then
		brightnessctl --quiet -d $(pick-display) set 5%-
	fi
done
