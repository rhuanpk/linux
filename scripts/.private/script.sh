#!/usr/bin/bash

# Internal descriptions.

# >>> built-in sets!
#set -ex +o histexpand

# >>> variables declaration!
readonly version='0.0.0'
readonly location="$(realpath -s "$0")"
readonly script="$(basename "$0")"
readonly uid="${UID:-$(id -u)}"
readonly user="$(id -un "${uid/#0/1000}")"
readonly home="/home/$user"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

DESCRIPTION
	Short description of how it works.

USAGE
	$script [<options>]

OPTIONS
	-s
		Forces keep sudo.
	-r
		Forces unset sudo.
	-v
		Print version.
	-h
		Print this help.
EOF
}

# OBSERVATIONS
#
# If you do not use sudo, delete all related parts!
#
# When called:
# - This retains $sudo:
# 	- Sets $sudo
# 	- SUDO flag: true
# 	- ROOT flag: true
#
# - This retains $sudo:
# 	- Sets $sudo
# 	- SUDO flag: true
# 	- ROOT flag: false
#
# - This unset $sudo:
# 	- Sets $sudo
# 	- SUDO flag: false
# 	- ROOT falg: true
#
# - This require root:
# 	- Not set $sudo
#
# For automatic:
# - Sets $sudo
# - SUDO flag: false
# - ROOT flag: false
# 	- If regular: retains $sudo
# 	- If root: unset $sudo
# - Or simply: privileges
#
# About the flags:
# - The `-s` forces retain $sudo
# - The `-r` forces unset $sudo
privileges() {
	local flag_sudo="${1:=false}"
	local flag_root="${2:=false}"
	sudo='sudo'
	if [[ -z "$sudo" && "$uid" -ne 0 ]]; then
		echo "$script: error: run as root #sudo"
		exit 1
	elif ! "$flag_sudo"; then
		if "$flag_root" || [ "$uid" -eq 0 ]; then
			unset sudo
		fi
	fi
}

check-needs() {
	privileges
	local packages=('package1' 'package2')
	for package in "${packages[@]}"; do
		if ! dpkg -s "$package" &>/dev/null; then
			read -rp "$script: info: is needed the \"$package\" package, install? [Y/n] "
			[ -z "$REPLY" ] || [ 'y' = "${REPLY,,}" ] && $sudo apt install -y "$package"
		fi
	done
}

# >>> pre statements!
privileges
check-needs

while getopts 'srvh' option; do
	case "$option" in
		s) privileges true false;;
		r) privileges false true;;
		v) echo "$version"; exit 0;;
		h) usage; exit 1;;
		*) exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
# path="~/.xpto"
# path="${path/#~/$HOME}"
