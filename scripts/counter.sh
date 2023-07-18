#!/usr/bin/env bash

# A simple counter that increments.

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
        echo -e "Run:\n\t./${script}"
}

# >>> pre statements !

set +o histexpand

#verify_privileges
[ $# -ge 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>> *** PROGRAM START *** !
declare -i answer
while :; do
	clear
	echo ">>> COUNT = ${count:-<nothing yet>}!"
	read -p 'I: ' answer
	[ 0 -eq "$answer" ] && let ++count || let count+=answer
done
