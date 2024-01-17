#!/usr/bin/bash

# Script that updates, fixes and cleans the system in one go.

# >>> built-in sets!
set -e

# >>> variables declaration!
readonly version='2.1.0'
readonly script="`basename "$0"`"
readonly uid="${UID:-`id -u`}"

SUDO='sudo'

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Execute "all" apt commands to fix, update and cleanup.

Usage: $script [<options>]

Options:
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
# Fix
${SUDO:+sudo -v}
echo '> dpkg --configure -a'
$SUDO dpkg --configure -a
echo '> apt install -fy'
$SUDO apt install -fy

# Update
${SUDO:+sudo -v}
echo '> apt update'
$SUDO apt update
echo '> apt upgrade -y'
$SUDO apt upgrade -y
echo '> apt install --upgradeable'
$SUDO apt list --upgradable 2>&- \
	| sed -nE 's~^(.*)/.*$~\1~p' \
	| xargs $SUDO apt install -y

# Clean
${SUDO:+sudo -v}
echo '> apt clean -y'
$SUDO apt clean -y
echo '> apt autoclean -y'
$SUDO apt autoclean -y
echo '> apt autoremove -y'
$SUDO apt autoremove -y

# Update and Clean
${SUDO:+sudo -v}
echo '> apt full-upgrade -y'
$SUDO apt full-upgrade -y
