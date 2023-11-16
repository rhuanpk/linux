#!/usr/bin/bash

# <comments>

# >>> built-in sets!
#set -ex +o histexpand

# >>> variable declaration!
readonly version='0.0.0'
location="`realpath "$0"`"
script="`basename "$0"`"
uid="${UID:-`id -u`}"
user="`id -un "${uid/#0/1000}"`"
home="/home/$user"

SUDO='sudo'

# >>> function declaration!
usage() {
cat << EOF
$script v$version

Short description of how it works.

Usage: $script [<options>]

Options:
	-s: Forces keep sudo;
	-r: Forces unset sudo;
	-v: Print version;
	-h: Print this help.
EOF
}

# Keeping set up the `SUDO` variable makes automatically retain or discard the sudo command.
# `-s` option forces to keep the sudo command.
# `-r` option forces to "unset" sudo command.
# Comment the `SUDO` variable to require run as root.
# Case not use sudo in the script don't worry, nothing changes.
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
while getopts 'srvh' option; do
	case "$option" in
		s) privileges true false;;
		r) privileges false true;;
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
# <commands>
