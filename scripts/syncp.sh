#!/usr/bin/bash

# Prints the disk synchronization.

# >>> built-in sets!
set +o histexpand

# >>> variables declaration!
readonly version='1.0.0'
readonly script="$(basename "$0")"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Prints the disk synchronization.

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
		h) usage; exit 1;;
		*) exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
sync &
sync_pid="$!"
sleep 1
while ps -qp "$sync_pid" &>/dev/null; do
	echo -en "\rSyncing $(grep -F 'Dirty:' /proc/meminfo | tr -s ' ' | cut -d' ' -f 2-)... "
	sleep 1
done
echo 'Done!'
