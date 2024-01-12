#!/usr/bin/bash

# Prints the battery percentage if it is "ac adapter".

# >>> variable declaration!
readonly version='1.1.0'
script="`basename "$0"`"

AC_ADAPTER=`acpi --ac-adapter 2>&1 | tr -d '[[:blank:]]' | cut -d ':' -f 2`

# >>> function declaration!
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
[ 'power_supply' = "$AC_ADAPTER" ] && IS_POWER_SUPPLY=true

if ! "${IS_POWER_SUPPLY:-false}"; then
	BATTERY_PERCENT=`acpi | tr -d '[[:blank:]]' | cut -d ',' -f 2`
	echo "⚡ ${BATTERY_PERCENT:-0%} “"
fi
