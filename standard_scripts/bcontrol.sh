#!/usr/bin/env zsh

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

#nohup terminator --borderless --geometry=175x30-0-0 --command='bcontrol.sh' &
