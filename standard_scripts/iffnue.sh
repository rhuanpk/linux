#!/usr/bin/env bash

# Errnue validate if you want to continue or no and respectively returns true or false.

# >>> variable declarations !

this_script=$(basename "${0}")
home=${HOME:-/home/${USER:-$(whoami)}}

# >>> function declarations !

verify_privileges() {
	[ $UID -eq 0 ] && {
		echo -e "ERROR: Run this program without privileges!\nExiting..."
		exit 1
	}
}

print_usage() {
	cat <<- eof
		#######################################################
		#
		# >>> $this_script !
		#
		# Return 1 for default value and 0 for 'y' or 'Y'.
		# For custom message pass your prhase like arguments.
		#
		# Run:
		# 	$this_script ['any number'] ['of'] ['messages']
		#
		#######################################################
	eof
}

# >>> pre statements !

set +o histexpand

verify_privileges
[ "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>> *** PROGRAM START *** !

message=${*:-continue? [y/N] }
read -rp "${message}" answer
[ -z "${answer}" ] || [ y != "${answer,,}" ] && exit 1 || exit 0
