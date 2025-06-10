#!/usr/bin/bash

# Script that updates, fixes and cleans the system in one go.

# >>> variables declaration!
readonly version='2.3.0'
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
	-y: Accept yes for all commands;
	-f: Perform the firmware update actions;
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
while getopts 'uyfsrvh' option; do
	case "$option" in
		u) FLAG_UPGRADABLE='true';;
		y) FLAG_YES='-y';;
		f) FLAG_FIRMWARE='true';;
		s) privileges true false;;
		r) privileges false true;;
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

privileges false false

# ***** PROGRAM START *****
log() {
	echo -e "\e[3;94m$*\e[m"
}

# fix
${SUDO:+sudo -v}
log "> apt -f $FLAG_YES install"
$SUDO apt -f $FLAG_YES install
log "> apt install -f $FLAG_YES"
$SUDO apt install -f $FLAG_YES
log '> dpkg --configure -a'
$SUDO dpkg --configure -a

# update
${SUDO:+sudo -v}
log '> apt update'
$SUDO apt update
log "> apt upgrade $FLAG_YES"
$SUDO apt upgrade $FLAG_YES
if "${FLAG_UPGRADABLE:-false}"; then
	log "> apt install --upgradeable $FLAG_YES"
	$SUDO apt list --upgradable 2>&- | sed -nE 's~^(.*)/.*$~\1~p' | xargs $SUDO apt install $FLAG_YES
fi

# agressive (update/clean/remove)
${SUDO:+sudo -v}
log "> apt full-upgrade $FLAG_YES"
$SUDO apt full-upgrade $FLAG_YES

# clean
${SUDO:+sudo -v}
log "> apt clean $FLAG_YES"
$SUDO apt clean $FLAG_YES
log "> apt autoclean $FLAG_YES"
$SUDO apt autoclean $FLAG_YES
log "> apt autoremove $FLAG_YES"
$SUDO apt autoremove $FLAG_YES

# firmware
log "> fwupdmgr update $FLAG_YES"
if "${FLAG_FIRMWARE:-false}"; then
	if which -s fwupdmgr || $SUDO apt install fwupd $FLAG_YES; then
		#fwupdmgr get-devices >&-
		fwupdmgr refresh
		fwupdmgr get-updates && fwupdmgr update $FLAG_YES
	fi
fi
