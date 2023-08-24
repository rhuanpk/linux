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

is-integer() {
	[[ "$1" =~ ^[0-9]*$ ]] && return 0 || return 1
}

cd /tmp

if `is-integer $1` && [ ! "${1:-0}" -gt 0 ]; then
	sleep .25
else
	if `is-integer $1`; then
		args_arr="-d $1 ${@:2}"
	else
		args_arr=$@
	fi
fi
[[ "$args_arr" =~ '-s' ]] && args_arr+=' -f'

scrot \
	$args_arr \
	-e 'xclip -selection clipboard -target image/png $f'

mv /tmp/*scrot.png ~/Pictures/screenshots/
