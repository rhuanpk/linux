#!/usr/bin/bash

# Sleep before suspend the system.

# >>> variables declaration!
readonly version='1.1.0'
readonly script="`basename "$0"`"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Sleep before suspend the system (via systemctl) and if not timeout is provided 0s is the default.

Usage: $script [<options>] [<timeout-seconds>]

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
dunstctl set-paused 'true' && polybar-msg action '#dunst.hook.1'
sleep "${1:-0}"; systemctl suspend
