#!/usr/bin/bash

# Internal descriptions.

# >>> built-in setups
#set -exE +o histexpand -o pipefail
#exec 3>&1 > >(tee /tmp/file.log) 2>&1

# >>> variables declaration
readonly version='0.0.0'
readonly location="$(realpath -s "$0")"
readonly script="$(basename "$0")"
readonly uid="${UID:-$(id -u)}"
readonly user="$(id -un "${uid/#0/1000}")"
readonly home="/home/$user"

# >>> functions declaration
failure() {
	notify-send "${script^^}" "Failed \"$BASH_COMMAND\"!"
}

#decoy() {}

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
	local flag_sudo="$1"
	local flag_root="$2"
	sudo='sudo'
	if [[ -z "$sudo" && "$uid" -ne 0 ]]; then
		echo "$script: error: run as root #sudo"
		exit 1
	elif ! "${flag_sudo:-false}"; then
		if "${flag_root:-false}" || [ "$uid" -eq 0 ]; then
			unset sudo
		fi
	fi
}

check-needs() {
	get_pm_cmd() {
		which -s apk && { echo 'apk add'; return; }
		which -s apt && { echo 'apt install'; return; }
		which -s dnf && { echo 'dnf install'; return; }
		which -s yum && { echo 'yum install'; return; }
		which -s pkg && { echo 'pkg install'; return; }
		which -s pacman && { echo 'pacman -S'; return; }
		which -s emerge && { echo 'emerge -av'; return; }
		which -s zypper && { echo 'zypper install'; return; }
		which -s portage && { echo 'portage install'; return; }
	}
	privileges
	local packages=('package1' 'package2')
	for package in "${packages[@]}"; do
		if ! dpkg -s "$package" &>/dev/null; then
			echo -ne "$script: ask: needed \"$package\", "
			read -rp  "install? [Y/n] "
			[ -z "$REPLY" ] || [ 'y' = "${REPLY,,}" ] && {
				$sudo `get_pm_cmd` "$package" || exit $?
			}
		fi
	done
}

# >>> pre statements
#trap failure ERR
#trap decoy EXIT

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
