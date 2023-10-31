#!/usr/bin/env bash

# <comments>

# >>> built-in sets!
#set -ex +o histexpand

# >>> variable declaration!
script="`basename $(readlink -f "$0")`"
user="${USER:-`id -un`}"
home="/home/$user"

SUDO='sudo'

# >>> function declaration!
usage() {
	echo "Usage; ./$script"
}

# >>> pre statements!
[ "${UID:-`id -u`}" -eq 0 ] && { unset SUDO; }

while getopts 'h' OPTION; do
	case "$OPTION" in
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))


# ***** PROGRAM START *****
# <commands>
