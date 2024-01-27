#!/usr/bin/bash

# <comments>

# >>> built-in sets!
#set -ex +o histexpand

# >>> variables declaration!
readonly version='0.0.0'
readonly location="`realpath "$0"`"
readonly script="`basename "$0"`"
readonly uid="${UID:-`id -u`}"
readonly user="`id -un "${uid/#0/1000}"`"
readonly home="/home/$user"

SUDO='sudo'

# >>> functions declaration!
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
		echo "$script: error: run with root privileges"
		exit 1
	elif ! "$FLAG_SUDO"; then
		if "$FLAG_ROOT" || [ "$uid" -eq 0 ]; then
			unset SUDO
		fi
	fi
}

check-needs() {
	privileges false false
	PACKAGES=('package1' 'package2')
	for package in "${PACKAGES[@]}"; do
		if ! dpkg -s "$package" &>/dev/null; then
			read -p "$script: is needed the \"$package\" package, install? [Y/n] " answer
			[ -z "$answer" ] || [ 'y' = "${answer,,}" ] && $SUDO apt install -y "$package"
		fi
	done
}

# >>> pre statements!
check-needs

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
