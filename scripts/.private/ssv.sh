#!/usr/bin/bash

# <comments>

# >>> built-in sets!
#set -ex +o histexpand

# >>> variables declaration!
# in this section we can break lines to better viewing
declare -gr version; version='0.0.0'
declare -gr location; location="$(realpath "$0")"
declare -gr script; script="$(basename "$0")"
declare -gr uid; uid="${UID:-$(id -u)}"
declare -gr user; user="$(id -un "${uid/#0/1000}")"
declare -gr home; home="/home/$user"

declare -g sudo; sudo='sudo'

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
#
# About the flags:
# - The `-s` forces retain $sudo
# - The `-r` forces unset $sudo
privileges() {
	declare flag_sudo; flag_sudo="$1"
	declare flag_root; flag_root="$2"
	if [[ -z "$sudo" && "$uid" -ne 0 ]]; then
		echo "$script: error: run with root privileges"
		exit 1
	elif ! "$flag_sudo"; then
		if "$flag_root" || [ "$uid" -eq 0 ]; then
			unset sudo
		fi
	fi
}

check-needs() {
	declare -a packages
	packages=('package1' 'package2')
	for package in "${packages[@]}"; do
		if ! dpkg -s "$package" &>/dev/null; then
			read -rp "$script: info: is needed the \"$package\" package, install? [Y/n] "
			[ -z "$REPLY" ] || [ 'y' = "${REPLY,,}" ] && $sudo apt install -y "$package"
		fi
	done
}

# >>> pre statements!
#privileges
privileges false false
check-needs

while getopts 'srvh' option; do
	case "$option" in
		s) privileges true false;;
		r) privileges false true;;
		v) echo "$version"; exit 0;;
		h|*) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
# <commands>
