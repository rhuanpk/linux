#!/usr/bin/bash

# Prints the battery percentage if it is "ac adapter".

# >>> variables declaration!
readonly version='1.1.0'
readonly script="`basename "$0"`"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Prints the battery percentage if it is "ac adapter".

Usage: $script [<options>]

Options:
	-v: Print version;
	-h: Print this help.
EOF
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
SYMBOL=$'\U1F5F2'
AC_ADAPTER=`acpi -a 2>&1 | tr -d '[[:blank:]]' | cut -d ':' -f 2`
[ 'power_supply' = "$AC_ADAPTER" ] && IS_POWER_SUPPLY=true

if ! "${IS_POWER_SUPPLY:-false}"; then
	BATTERY_PERCENT=`acpi -b | tr -d '[[:blank:]]' | cut -d ',' -f 2 | cut -d '%' -f 1`
	case "`acpi -b`" in
		*Full*|*Not*) echo -e "$SYMBOL %{T4}${BATTERY_PERCENT:-0}%{T-}%";;
		*Charging*) echo -e "$SYMBOL ${BATTERY_PERCENT:-0}%";;
		*Discharging*) echo -e "$SYMBOL %{F#FF00FF}${BATTERY_PERCENT:-0}%{F-}%";;
		*Low*) echo -e "$SYMBOL %{F#BD2C40}${BATTERY_PERCENT:-0}%{F-}%";;
	esac
fi
