#!/usr/bin/env bash

# This script sets up global variables for the repositories.
# Has defined the variables passed as param to the setload function in /etc/environment file.

# >>> built-in sets!
#set -e

# >>> variable declaration!
script="`basename $(readlink -f "$0")`"
uid="${UID:-`id -u`}"
user="${USER:-`id -un "$uid"`}"
home="/home/$user"

SUDO='sudo'

# >>> function declaration!
usage() {
cat << EOF
Usage: ./$script [<option>]

Options:
	-s: Forces keep sudo;
	-r: Forces unset sudo;
	-h: Print this help.
EOF
}

setload() {
	VARIABLE_NAME=${1:?'needs a variable to set'}
	REPO_NAME=${2:?'needs the name of the repository to be loaded'}

        ENVIRONMENT_PATH=/etc/environment
	FULL_PATH=$(
		EXCLUDE_FOLDERS='pCloudDrive|googleDrive|tmp'
		find $home/ -type f -name ".way-flag-$REPO_NAME.cfg" 2>&- \
		| sed -E "/${EXCLUDE_FOLDERS:-`uuidgen`}/d" \
		| xargs dirname 2>&- \
		| tail -1
	)
	LINE_AND_PATH=$(grep -nE "$VARIABLE_NAME=.*$" ${ENVIRONMENT_PATH:?'missing environment path'})
	[ ! -z "$LINE_AND_PATH" ] && {
		# this command grab the return code of command not found case sudo is not found what cause no errexit triggered by `set -e`
		if ! $SUDO sed -i "${LINE_AND_PATH%:*}s~=${LINE_AND_PATH#*=}~=$FULL_PATH~" $ENVIRONMENT_PATH 2>&-; then
			echo $FULL_PATH
		fi
	} || echo $FULL_PATH
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

if [[ -z "$SUDO" && "$uid" -ne 0 ]]; then
	echo "$script: run with root privileges"
	exit 1
elif ! "${FLAG_SUDO:-false}"; then
	if "${FLAG_ROOT:-false}" || [[ -n "$SUDO" && "$uid" -eq 0 ]]; then
		unset SUDO
	fi
fi

# ***** PROGRAM START *****
setload PK_LOAD_CFGBKP cfg-bkp
setload PK_LOAD_LINUX linux
#setload PK_LOAD_PKUTILS pkutils
