#!/usr/bin/bash

# Script that updates, fixes and cleans the system in one go.

# >>> built-in sets!
set -e

# >>> variables declaration!
readonly version='2.2.0'
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
	-u: Forces try install upgradable packages;
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
while getopts 'usrvh' option; do
	case "$option" in
		u) FLAG_UPGRADABLE='true';;
		s) privileges true false;;
		r) privileges false true;;
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

privileges false false

# ***** PROGRAM START *****
# fix
${SUDO:+sudo -v}
echo '> apt install -fy'
$SUDO apt install -fy
echo '> dpkg --configure -a'
$SUDO dpkg --configure -a

# update
${SUDO:+sudo -v}
echo '> apt update'
$SUDO apt update
echo '> apt upgrade -y'
$SUDO apt upgrade -y
if "${FLAG_UPGRADABLE:-false}"; then
	echo '> apt install --upgradeable'
	$SUDO apt list --upgradable 2>&- | sed -nE 's~^(.*)/.*$~\1~p' | xargs $SUDO apt install -y
fi

# agressive (update/clean/remove)
${SUDO:+sudo -v}
echo '> apt full-upgrade -y'
$SUDO apt full-upgrade -y

# clean
${SUDO:+sudo -v}
echo '> apt clean -y'
$SUDO apt clean -y
echo '> apt autoclean -y'
$SUDO apt autoclean -y
echo '> apt autoremove -y'
$SUDO apt autoremove -y
