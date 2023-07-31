#!/usr/bin/env bash

# Volume control.
# Necessary: terminator && xdotool.

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
[ $# -ge 1 -o "${1}" = '-h' -o "${1}" = '--help' ] && {
        print_usage
        exit 1
}

# >>> *** PROGRAM START *** !
percent_volume() {
	amixer -M get 'Master' | tail -n 1 | awk '{print $4}' | sed -E "s/\[|\]//g"
}

# xdotool key "ctrl+alt+x" type 'Volume (sair = q)'; xdotool key "KP_Enter"

while :; do
	clear
	echo -n "Volume: $(percent_volume) [+/-]? "; read -n 1 VALUE
	[ "${VALUE}" = "q" -o "${VALUE}" = "Y" ] && exit 0
	amixer set 'Master' 1%${VALUE} 1>/dev/null
done

# nohup terminator --borderless --geometry=175x30-0-0 --command='vc' &
