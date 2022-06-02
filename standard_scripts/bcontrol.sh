#!/usr/bin/env zsh

pick_display() {
	echo $(brightnessctl -l | egrep -i '(backlight)' | tr ' ' '\n' | egrep '0' | tr -d "'" | tail -n 1)
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
