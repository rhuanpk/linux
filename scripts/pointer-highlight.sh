#!/usr/bin/env bash

# Start or kill the highlight-pointer.

# >>> variable declarations !
SCRIPT=`basename "$0"`
HOME=${HOME:-/home/${USER:-`id -un`}}

# >>> function declarations !
verify_privileges() {
	[ $UID -eq 0 ] && {
		echo -e "ERROR: Run this program without privileges!\nExiting..."
		exit 1
	}
}

print_usage() {
        echo -e "Run:\n\t./$SCRIPT"
}

# >>> pre statements !
set +o histexpand

#verify_privileges
[ "$#" -ge 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>> *** PROGRAM START *** !
if ! ps -C highlight-pointer &>/dev/null; then
	highlight-pointer \
		--show-cursor \
		-o 3 \
		-r 27.5 \
		-c '#303030' \
		-p '#a41313' \
		-t 1 \
		--auto-hide-cursor \
		--auto-hide-highlight
else
	killall highlight-pointer
fi
