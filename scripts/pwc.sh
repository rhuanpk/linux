#!/usr/bin/env bash

# Tira prints com o scrot e já manda pro diretório correto.

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

verify_privileges
[ "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>> *** PROGRAM START *** !

# example:
# scrot -d 1 -s -p -e 'xclip -selection clipboard -target image/png $f'

cd /tmp

[[ "$1" =~ ^[0-9]*$ ]] && [ ! "${1:-0}" -gt 0 ] && {
	sleep .25
} || {
	[[ "$1" =~ ^[0-9]*$ ]] && {
		args_arr="-d $1 ${@:2}"
	} || {
		args_arr=$@
	}
}

scrot \
	$args_arr \
	-e 'xclip -selection clipboard -target image/png $f'

mv /tmp/*scrot.png ~/Pictures/screenshots/
