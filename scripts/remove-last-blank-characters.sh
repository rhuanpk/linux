#!/usr/bin/env bash

# Remove Last Clank character remove thats in all lines in file passed like argument.

# >>> variable declarations !

script=$(basename "${0}")
home=${HOME:-/home/${USER:-$(whoami)}}

readonly version=0.0.0

# >>> function declarations !

verify_privileges() {
	[ $UID -eq 0 ] && {
		echo -e "ERROR: Run this program without privileges!\nExiting..."
		exit 1
	}
}

print_usage() {
	cat <<- eof
		####################################################################################################
		#
		# >>> $script !
		#
		# DESCRIPTION
		# 	Remove Last Blank Character (rlbc) remove thats in all lines in passed file like argument.
		#
		# USAGE
		# 	$script [-hv] /path/to/file.any
		#
		# OPTIONALS
		# 	-v, --version
		# 		Print the versions and exit with 0.
		#
		# 	-h, --help
		# 		Print this help and exit with 0.
		#
		####################################################################################################
	eof
}

# >>> pre statements !

set +o histexpand

#verify_privileges
while getopts 'hv' option; do
	case $option in
		v) echo "${script}: version ${version}!"; exit 0;;
		h) print_usage; exit 0;;
	esac
done
shift $((${OPTIND}-1))

# >>> *** PROGRAM START *** !
file="${1:?need a file to argument!}"
sed -Ei 's/[[:blank:]]+$//g' $file
