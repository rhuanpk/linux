#!/usr/bin/bash

# <comments>

# >>> built-in sets!
#set -ex +o histexpand

# >>> variable declaration!
readonly version='0.0.0'
readonly location="`realpath "$0"`"
readonly script="`basename "$0"`"
readonly uid="${UID:-`id -u`}"
readonly user="`id -un "${uid/#0/1000}"`"
readonly home="/home/$user"

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

# Observations:
# - If you do not use sudo, delete all related parts;
# - If using sudo:
# 	- If you want to change the sudo state only via option, delete the automatic privilege;
# 	- If you have disabled automatic privileges and need pre getopts scaling, use it before it.
# 	- (maybe necessary add a else clausule to sets up $SUDO variable again?)
# - About the flags:
# 	- The `-s` option forces retention of the sudo command;
# 	- The `-r` option forces the sudo command to be "disabled".
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

privileges false false

# ***** PROGRAM START *****
# <commands>
