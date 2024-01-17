#!/usr/bin/env bash

# Volume control.
# Necessary: terminator && xdotool.

# >>> variable declarations !
script=`basename $(readlink -f "$0")`

# >>> function declarations !
verify_privileges() {
	[ "${UID:-`id -u`}" -eq 0 ] && {
		echo -e "ERROR: Run this program without privileges!\nExiting..."
		exit 1
	}
}

print-usage() {
        echo -e "Run:\n\t./${script}"
}

# >>> pre statements !
set +o histexpand

#verify_privileges
[ "$#" -ge '1' -o "$1" = '-h' -o "$1" = '--help' ] && {
        print-usage
        exit 1
}

# >>> *** PROGRAM START *** !
# nohup terminator --borderless --geometry=175x30 --command='$script' &

volume-level() {
	wpctl get-volume '@DEFAULT_AUDIO_SINK@' | cut -d ' ' -f 2	
}

validate-input() {
	REGEX=${1:?need args to compare}
	COMPARE=${@:2}
	[ "${COMPARE,,}" = 'q' ] && exit 0
	[[ "$COMPARE" =~ ["$REGEX"] ]]
	return
}

while :; do
	clear
	VOLUME=`volume-level`
	[ `/usr/bin/bc <<< "$VOLUME < 1"` -eq 1 ] && {
		read -n 1 -p "V0lum3: $VOLUME [+/-]? " ANSWER
		if validate-input '+-' "$ANSWER"; then
			wpctl set-volume '@DEFAULT_AUDIO_SINK@' ".05$ANSWER"
		fi
	} || {
		read -n 1 -p "V0lum3: $VOLUME (max) [-]: " ANSWER
		if validate-input '-' "$ANSWER"; then
			wpctl set-volume '@DEFAULT_AUDIO_SINK@' '.05-'
		fi
	}
done
