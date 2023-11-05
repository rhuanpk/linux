#!/usr/bin/bash

# Get the RAM consumption of some specific program.

# >>> variable declaration!
readonly version='2.0.0'
script="`basename "$0"`"
uid="${UID:-`id -u`}"

SUDO='sudo'

# >>> function declaration!
usage() {
cat << EOF
$script v$version

Pass the name of some program to know your RAM consume.

Usage: $script [<options>] 'program'

Options:
	-f: Full output.
	-s: Forces keep sudo;
	-r: Forces unset sudo;
	-v: Print version;
	-h: Print this help.
EOF
}

not-installed() {
cat << EOF
$script: --------------------------------------------
$script: |   Necessary install the program: SMEM    |
$script: |                                          |
$script: |   Enter - Proced with the installation   |
$script: |   Ctrl+c - Exit                          |
$script: --------------------------------------------
EOF
}

lower2upper() {
	echo "$1" | tr '[:lower:]' '[:upper:]'
}

# >>> pre statements!
while getopts 'fsrvh' OPTION; do
	case "$OPTION" in
		f) FLAG_FULL=true;;
		s) FLAG_SUDO=true;;
		r) FLAG_ROOT=true;;
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

if [[ -z "$SUDO" && "$uid" -ne 0 ]]; then
	echo "$script: run with root privileges"
	exit 1
elif ! "${FLAG_SUDO:-false}"; then
	if "${FLAG_ROOT:-false}" || [ "$uid" -eq 0 ]; then
		unset SUDO
	fi
fi

# ***** PROGRAM START *****
if ! dpkg -l smem &>/dev/null; then
        not-installed \
	&& read readkey \
	&& $SUDO apt install smem -y
fi

if ! dpkg -l "$1" &>/dev/null; then echo 'The program name can be not exists...'; fi
if ! "${FLAG_FULL:-false}"; then
	echo -e "\e[1m`lower2upper "$1"`\e[m: `smem -aktP "$1" | tail -1 | tr -s ' ' | cut -d ' ' -f 5` (RAM)"
else
	smem -aktP "$1"
fi
