#!/usr/bin/bash

# Decrease or increase pointer speed.

# >>> variable declaration!
readonly version='1.1.0'
script="`basename "$0"`"

# >>> function declaration!
usage() {
cat << EOF
$script v$version

Change pointer speed.

Usage: $script [<options>]

Options:
	-v: Print version;
	-h: Print this help.
EOF
}

get-device-id() {
	DEVICE="$1"
	echo "`xinput list --short |  sed -nE "/$DEVICE/{s/^.*$DEVICE.*id=([[:digit:]]+).*pointer.*$/\1/p;q}"`"
}

get-old-value() {
	echo "`xinput list-props "$DEVICE_ID" | grep -iE '(Accel Speed \()' | tr -d '[[:blank:]]' | cut -d ':' -f 2 | grep -oiE '^-?[[:digit:]]{1}\.[[:digit:]]{1}'`"
}

operation() {
	SIGNAL="$1"
	OLD_VALUE="`get-old-value`"
	[ -z "$OLD_VALUE" ] && OLD_VALUE='0.0'
	xinput set-prop "$DEVICE_ID" "$PROPERTY_ID" `/usr/bin/bc <<< "$OLD_VALUE${SIGNAL}0.1"` 2>&-
}


# >>> pre statements!
while getopts 'vh' OPTION; do
	case "$OPTION" in
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
DEVICE_ID="`get-device-id 'Mouse'`"
if ! lsusb | grep -qi mouse || [ -z "$DEVICE_ID" ]; then
	DEVICE_ID="`get-device-id 'Touchpad'`"
fi
PROPERTY_ID=$(
	xinput list-props "$DEVICE_ID" \
	| grep -oiE '(Accel Speed \([[:digit:]]+)' \
	| cut -d '(' -f 2
)
while :; do
	clear
	read -n 1 -p "Sp33d P01n73r: `get-old-value` [+/-]? " answer
	[ 'q' = "${answer,,}" ] && break || {
		if [ '-' = "$answer" ]; then
			operation "$answer"
		elif [ '+' = "$answer" ]; then
			operation "$answer"
		fi
	}
done
