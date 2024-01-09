#!/usr/bin/bash

# Prints the CPU usage for polybar module.

# >>> variable declaration!
readonly version='1.0.0'
script="`basename "$0"`"

# >>> function declaration!
usage() {
cat << EOF
$script v$version

Prints the CPU usage for polybar module.

Usage: $script [<options>]

Options:
	-v: Print version;
	-h: Print this help.
EOF
}

# >>> pre statements!
while getopts 'vh' option; do
	case "$option" in
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
while :; do
	CPU_INFOS=`head -1 /proc/stat | sed -E 's/(^cpu[[:blank:]]+)//;s/[[:blank:]]{2,}/ /g'`
	CPU_TOTAL_ATUAL=$((`tr ' ' '+' <<< "$CPU_INFOS"`))
	CPU_TOTAL_DELTA=$(("$CPU_TOTAL_ATUAL"-"${CPU_TOTAL_LAST:-0}"))
	CPU_IDLE_ATUAL=`cut -d ' ' -f 4 <<< "$CPU_INFOS"`
	CPU_IDLE_DELTA=$(("$CPU_IDLE_ATUAL"-"${CPU_IDLE_LAST:-0}"))
	CPU_USAGE=$(command -p bc <<< "scale=10;($CPU_TOTAL_DELTA-$CPU_IDLE_DELTA)/$CPU_TOTAL_DELTA*100" | cut -d '.' -f 1)
	echo "CPU: ${CPU_USAGE:-0}% |"
	CPU_TOTAL_LAST=$CPU_TOTAL_ATUAL
	CPU_IDLE_LAST=$CPU_IDLE_ATUAL
	sleep 3
done
