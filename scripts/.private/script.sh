#!/usr/bin/bash

# Internal descriptions.

# >>> built-in setups
#shopt -s globstar
#set -exCE +H -o pipefail
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
		Force keep the sudo.
	-r
		Force run as root.
	-v
		Print version.
	-h
		Print this help.
EOF
}

# OBSERVATIONS!
#
# If you d'not use sudo, delete all related parts.
#
# When called:
# - This run root:
# 	- ROOT flag: true
#
# - This retains $sudo:
# 	- SUDO flag: true
#
# For automatic:
# - SUDO flag: false
# - ROOT flag: false
# 	- If regular: retains $sudo
# 	- If root: unset $sudo
# - Or simply: privileges
#
# About the flags:
# - `-s` force retain $sudo
# - `-r` force run root
privileges() {
	local flag_sudo="$1"
	local flag_root="$2"
	: ${uid:?need set uid}
	if "${flag_root:-false}"; then
		((uid != 0)) && {
			echo "$script: error: run as root (!sudo)" >&2
			exit 1
		}
		unset sudo
		return 0
	fi
	if "${flag_sudo:-false}"; then
		sudo='sudo'
		return 0
	fi
	sudo='sudo'
	((uid == 0)) && unset sudo
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
		if ! which -s "$package"; then
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
shift $((OPTIND-1))

# ***** PROGRAM START *****
# path="~/.xpto"
# path="${path/#~/$HOME}"
