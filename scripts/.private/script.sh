#!/usr/bin/env bash

# <comments>

# >>> built-in sets!
#set -ex +o histexpand

# >>> variable declaration!
script="`basename $(readlink -f "$0")`"
uid="${UID:-`id -u`}"
user="${USER:-`id -un "$uid"`}"
home="/home/$user"

SUDO='sudo'

# >>> function declaration!
usage() {
	echo "usage; ./$script"
}

# >>> pre statements!
while getopts 'srh' OPTION; do
	case "$OPTION" in
		s) FLAG_SUDO=true;;
		r) FLAG_ROOT=true;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# Keeping set up the `SUDO` variable makes automatically retain or discard the sudo command.
# `-s` option forces to keep the sudo command.
# `-r` option forces to "unset" sudo command.
# Comment the `SUDO` variable to require run as root.
# Case not use sudo in the script don't worry, nothing changes.
if [[ -z "$SUDO" && "$uid" -ne 0 ]]; then
	echo "$script: run with root privileges"
	exit 1
elif ! "${FLAG_SUDO:-false}"; then
	if "${FLAG_ROOT:-false}" || [[ -n "$SUDO" && "$uid" -eq 0 ]]; then
		unset SUDO
	fi
fi

# ***** PROGRAM START *****
# <commands>
