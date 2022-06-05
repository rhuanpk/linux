#!/usr/bin/env bash

# A simple counter that increments

verify_privileges() {
        if [ ${UID} -eq 0 ]; then
                echo -e "ERROR: Run this program without privileges!\nExiting..."
                exit 1
        fi
}

print_usage() {
        echo -e "Run:\n\t./$(basename ${0})"
}

# verify_privileges

[ ${#} -ge 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>>>> PROGRAM START <<<<<

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
