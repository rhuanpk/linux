#!/usr/bin/env bash

# A simple counter that increments.

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
        echo -e "Run:\n\t./${this_script}"
}

# >>> pre statements !

set +o histexpand

#verify_privileges
[ $# -ge 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>> *** PROGRAM START *** !

counter() {
	read foo; [ "${foo,,}" = "q" ] && exit 0
	bar=${foo}
	clear
	echo -ne "  >>> CONTADOR = ${bar} !\r"
}

counter

while :; do
	counter
done
