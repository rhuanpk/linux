#!/usr/bin/bash

# Try fix brokened packages.

# >>> built-in sets!
set -e

# >>> variable declaration!
readonly version='1.1.0'
script="`basename "$0"`"

SUDO='sudo'

# >>> function declaration!
usage() {
cat << EOF
$script v$version

Execute apt commands to fix up packages.

Usage: $script [<option>]

Options:
	-s: Forces keep sudo;
	-r: Forces unset sudo;
	-v: Print version;
	-h: Print this help.
EOF
}

# >>> pre statements!
while getopts 'srvh' OPTION; do
	case "$OPTION" in
		s) FLAG_SUDO=true;;
		r) FLAG_ROOT=true;;
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

if [[ -z "$SUDO" && "$uid" -ne 0 ]]; then
	echo "$script: run with root privileges"
	exit 1
elif ! "${FLAG_SUDO:-false}"; then
	if "${FLAG_ROOT:-false}" || [ "$uid" -eq 0 ]; then
		unset SUDO
	fi
fi

# ***** PROGRAM START *****
$SUDO dpkg --configure -a
$SUDO apt install -fy
