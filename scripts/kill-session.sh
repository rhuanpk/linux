#!/usr/bin/bash

# Restart the session.

# >>> variables declaration!
readonly version='1.1.0'
readonly script="`basename "$0"`"
readonly uid="${UID:-`id -u`}"
readonly user="`id -un "${uid/#0/1000}"`"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Restart the current user session killing all running user process.

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
pkill -9 -u "$user"
