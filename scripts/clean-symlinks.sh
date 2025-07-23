#!/usr/bin/bash

# Clean Broken Symlinks.

# >>> variables declaration!
readonly version='1.0.0'
readonly script="`basename "$0"`"
readonly uid="${UID:-`id -u`}"

SUDO='sudo'
PATHWAY="`pwd`"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Clean up (exclude) all broken symlinks in folder.

Usage: $script [<options>]

Options:
	-p <path>: Specify path where are symlinks (default is current directory);
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
while getopts 'p:srvh' option; do
	case "$option" in
		p) PATHWAY="$OPTARG";;
		s) privileges true false;;
		r) privileges false true;;
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

privileges false false

# ***** PROGRAM START *****
$SUDO find "$PATHWAY" -xtype l -exec rm -fv '{}' \;
