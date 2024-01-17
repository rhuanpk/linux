#!/usr/bin/bash

# Prints the volume level for polybar module.

# >>> variables declaration!
readonly version='1.0.0'
readonly script="`basename "$0"`"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Prints the volume level for polybar module.

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
	VOLUME="`wpctl get-volume '@DEFAULT_AUDIO_SINK@'`"
	[[ "$VOLUME" =~ MUTED ]] && SYMBOL='✗' || SYMBOL='♪'
	echo "$SYMBOL $(printf '%.0f' $(bc <<< "`cut -d ' ' -f 2 <<< "$VOLUME"`*100"))%"
	sleep .1
done
