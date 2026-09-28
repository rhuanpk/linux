#!/usr/bin/bash

# Try fix brokened packages.

# >>> built-in sets!
set -e

# >>> variables declaration!
readonly version='1.2.0'
readonly script="`basename "$0"`"
readonly uid="${UID:-`id -u`}"

SUDO='sudo'

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Execute apt commands to fix up packages.

Usage: $script [<options>]

Options:
	-y: Accept yes for all commands;
	-c: Runs apt fix first;
	-s: Forces keep sudo;
	-r: Forces unset sudo;
	-v: Print version;
	-h: Print this help.
EOF
}

privileges() {
	FLAG_SUDO="${1:?needs sudo flag}"
	FLAG_ROOT="${2:?needs root flag}"
	if [[ -z "$SUDO" && "$uid" -ne 0 ]]; then
		echo "$script: run with root privileges"
		exit 1
	elif ! "$FLAG_SUDO"; then
		if "$FLAG_ROOT" || [ "$uid" -eq 0 ]; then
			unset SUDO
		fi
	fi
}

# >>> pre statements!
while getopts 'ycsrvh' option; do
	case "$option" in
		y) FLAG_YES='-y';;
		c) APT_FIRST='true';;
		s) privileges true false;;
		r) privileges false true;;
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

privileges false false

# ***** PROGRAM START *****
if "${APT_FIRST:-false}"; then
	$SUDO apt install -f $FLAG_YES
	$SUDO dpkg --configure -a
else
	$SUDO dpkg --configure -a
	$SUDO apt install -f $FLAG_YES
fi
