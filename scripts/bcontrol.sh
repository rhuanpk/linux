#!/usr/bin/env zsh

# Brightness control.

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
pick_display() {
	echo $(brightnessctl -l | grep -Ei '(backlight)' | tr ' ' '\n' | sed -n 2p | tr -d "'" | tail -n 1)
}

get_brighteness_percent() {
	brightnessctl get -d $(pick_display)
}

while :; do
	clear
	echo -n "Brilho $(get_brighteness_percent)0% [+/-]? "; read -k 1 VALUE
	if [ "${VALUE}" = "q" -o "${VALUE}" = "Q" ]; then
		exit 0
	elif [ "${VALUE}" = "+" ]; then
		sudo brightnessctl --quiet -d $(pick_display) set +5%
	elif [ "${VALUE}" = "-" ]; then
		sudo brightnessctl --quiet -d $(pick_display) set 5%-
	fi
done

# nohup terminator --borderless --geometry=175x30-0-0 --command='bcontrol.sh' &
