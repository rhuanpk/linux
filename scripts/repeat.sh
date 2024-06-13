#!/usr/bin/bash

# Loop for commands.

# >>> variables declaration!
readonly version='2.0.0'
readonly script="`basename "$0"`"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Script that leaves some command in a loop with update time control.

Syntax:
	$script <time> <command>

Usage:
	$script 3 lsblk
	$script 1 'sudo fdisk -l'
	$script 5 "ls -lhAF ~/"

Options:
	- <time>: Time (in seconds thats can are decimal values) to updating:
	- <command>: Command to reapeat.
	-v: Print version;
	-h: Print this help.

Tips/Tricks:
	- If you want to repeat any alias or custom function, use BASH_ENV in-line.
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
trap 'unset TIME COMMAND' EXIT
COMMAND='ls --color=always -lhAF'
if [[ "$1" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
	TIME="$1"
	[ "$#" -gt '1' ] && { COMMAND="$2"; ARGS="${*:3}"; }
else
	TIME='1'
	[ "$#" -gt '0' ] && { COMMAND="$1"; ARGS="${*:2}"; }
fi

if alias "$COMMAND" &>/dev/null; then
	COMMAND="$(sed -En "s/^alias $COMMAND='(.*)'$/\1/p" <<< "`alias $COMMAND`")"
fi

while :; do
	clear
	eval "${COMMAND:?'needs informe a command to run as second param'} $ARGS"
	sleep "${TIME:?'needs informe a time delay as first param'}"
done
