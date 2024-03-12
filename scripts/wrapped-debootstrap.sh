#!/usr/bin/bash

# Wrapped debootstrap with listing distro codenames.

# >>> built-in sets!
set +o histexpand

# >>> variables declaration!
readonly version='1.0.0'
readonly script="`basename "$0"`"
readonly uid="${UID:-`id -u`}"

SUDO='sudo'

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Wrapped Debootstrap with listing distro codenames.

If desired, pass standard debootstrap options at the end of the command.

Usage: $script [<options>] /path/to/debootstrap/folder [<debootstrap-options>]

Options:
	-l: List codename versions;
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
	PACKAGES=('debootstrap')
	for package in "${PACKAGES[@]}"; do
		if ! dpkg -s "$package" &>/dev/null; then
			read -p "$script: info: is needed the \"$package\" package, install? [Y/n] " answer
			[ -z "$answer" ] || [ 'y' = "${answer,,}" ] && $SUDO apt install -y "$package"
		fi
	done
}

get-codenames() {
	RED=$'\033[31m'
	YELLOW=$'\033[33m'
	MAGENTA=$'\033[35m'
	CYAN=$'\033[36m'
	BOLD=$'\033[01m'
	RESET=$'\033[00m'
	if ! CURL="`curl -fsSL 'https://www.debian.org/releases/'`"; then
		echo 'WARN: have some network problem? :/' >&2
		return 1
	fi
	INFOS="`\
		pandoc -t 'plain' -f 'html' --columns='100' <<< "$CURL"\
		| sed -n '/^Index of releases$/,/^.*Debian.*2\.0.*$/p'\
	`"
	cat <<- EOF
		- ${RED}sid$RESET $BOLD??$RESET (${YELLOW}unstable$RESET)
		- $MAGENTA`sed -nE "s/^.*“(.*)”.*“testing”.*$/\1/p" <<< "$INFOS"`$RESET $BOLD??$RESET (${YELLOW}testing$RESET)
		`\
			sed -nE "s/^.*(\ [[:digit:]]+\.?[[:digit:]]*).*\(“(.*)”\).*(“(.*)”|(extended|obsolete)).*$/- $CYAN\2$RESET$BOLD\1$RESET ($YELLOW\4\5$RESET)/p" <<< "$INFOS"\
			| tr -s '[[:blank:]]'\
		`
	EOF
}

print-codenames() {
	CODENAMES="$(get-codenames)" || exit
	cat <<- EOF
		From "https://www.debian.org/releases/":

		Debian releases:
		$CODENAMES
	EOF
}

# >>> pre statements!
check-needs

while getopts 'lsrvh' option; do
	case "$option" in
		l) print-codenames; exit;;
		s) privileges true false;;
		r) privileges false true;;
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

privileges false false

# ***** PROGRAM START *****
PATHWAY="${1:?fisrt param must be the debootstrap folder path}"
OPTIONS="${*:2}"
FOLDER="`realpath -L "$PATHWAY"`"
CODENAMES="$(get-codenames)" || exit
IFS=$'\n' read -d '' -a CODENAMES <<< "$CODENAMES"
clear; echo -e "$script (Wrapped Debootstrap) v$version\n"
[ -d "$FOLDER/" ] && {
	echo 'WARN: the path folder already exists'
	read -p 'Overwrite existing folder? [y/N] '
	[ -z "$REPLY" ] || [ 'y' != "${REPLY,,}" ] && exit || rm -rfv "$FOLDER"
	echo
}
while :; do
	echo 'Choose the Debian version:'
	for codename in "${CODENAMES[@]}"; do
		sed "s/^/${COUNT:=1} /" <<< "$codename"
		let COUNT++
	done
	echo -ne "\nOption [1-$(("$COUNT"-1))]: "; read
	IDS="`seq -s \| 1 $(("$COUNT"-1))`"
	[[ "$REPLY" =~ ^($IDS)$ ]] && break || {
		echo -n 'ERR: wrong option, select again'
		read -p ' - <enter>'
		unset COUNT; clear
	}
done
set -e
$SUDO debootstrap\
	"$(sed -nE 's/^.*[1-9]m([^\^]+)\^\[.*$/\1/p' <(cat -v <<< "`cut -d ' ' -f 2 <<< "${CODENAMES[$(("$REPLY"-1))]}"`"))"\
	"$FOLDER"\
	$OPTIONS
read -p "Exec \"mount -v proc $FOLDER/proc -t proc\"? [y/N] "
[ -z "$REPLY" ] || [ 'y' != "${REPLY,,}" ] || $SUDO mount -v proc "$FOLDER/proc" -t proc
read -p "Exec \"mount -v sysfs $FOLDER/sysfs -t sysfs\"? [y/N] "
[ -z "$REPLY" ] || [ 'y' != "${REPLY,,}" ] || $SUDO mount -v sysfs "$FOLDER/sys" -t sysfs
read -p "Exec \"mount -v devpts $FOLDER/dev/pts -t devpts\"? [y/N] "
[ -z "$REPLY" ] || [ 'y' != "${REPLY,,}" ] || $SUDO mount -v devpts "$FOLDER/dev/pts" -t devpts
read -p "Exec \"cp -v /etc/hosts $FOLDER/etc/hosts\"? [y/N] "
[ -z "$REPLY" ] || [ 'y' != "${REPLY,,}" ] || $SUDO cp -v '/etc/hosts' "$FOLDER/etc/hosts"
read -p "Exec \"cp -v '/proc/mounts' '$FOLDER/etc/mtab'\"? [y/N] "
[ -z "$REPLY" ] || [ 'y' != "${REPLY,,}" ] || $SUDO cp -v '/proc/mounts' "$FOLDER/etc/mtab"
echo "INFO: if mounted any device umount them after finished the lab: umount $FOLDER/*/**"
