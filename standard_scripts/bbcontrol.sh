#!/usr/bin/env bash

# Brightness control (bad)

verify_privileges() {
        if [ ${UID} -eq 0 ]; then
                echo -e "ERROR: Run this program without privileges!\nExiting..."
                exit 1
        fi
}

print_usage() {
        echo -e "Run:\n\t./$(basename ${0})"
}

verify_privileges

[ ${#} -ge 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>>>> PROGRAM START <<<<<

BRILHO1=0
BRILHO2=4

while :; do
	clear
	echo -n "Brilho: ${BRILHO1}.${BRILHO2} [+/-]? "; read -k 1 VALUE
	if [ "${VALUE}" = "q" -o "${VALUE}" = "Q" ]; then
		exit 0
	elif [ "${VALUE}" = "+" ]; then
		let ++BRILHO2
		if [ ${BRILHO2} -ge 10 ]; then
			let ++BRILHO1
			BRILHO2=0
			VALUE=$(echo "${BRILHO1}.${BRILHO2}")
		else
			VALUE=$(echo "${BRILHO1}.${BRILHO2}")
		fi
	elif [ "${VALUE}" = "-" ]; then
		let --BRILHO2
		if [ ${BRILHO2} -le -1 ]; then
			let --BRILHO1
			BRILHO2=9
			VALUE=$(echo "${BRILHO1}.${BRILHO2}")
		else
			VALUE=$(echo "${BRILHO1}.${BRILHO2}")
		fi
	fi
	xrandr --output $(xrandr -q | grep ' connected' | head -n 1 | cut -d ' ' -f 1) --brightness ${VALUE}
done

# nohup terminator --borderless --geometry=175x30-0-0 --command='bcontrol.sh' &
