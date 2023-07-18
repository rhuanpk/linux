#!/usr/bin/env bash

# Call the "plock" and suspend the system.

# >>> variable declarations !

script=$(basename "${0}")
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
		##################################################
		#
		# >>> $script !
		#
		# Custom screen suspender.
		#
		# Usage:
		#
		# 	$script [<timeout_seconds>]
		#
		##################################################
	eof
}

# >>> pre statements !

set +o histexpand

verify_privileges
[ $# -gt 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>> *** PROGRAM START *** !
sleep "${1:-0}"; plock && sudo systemctl suspend
