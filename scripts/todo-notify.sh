#!/usr/bin/bash

# Send notification to desktop to remind todo list.

# >>> built-in sets!
#set -ex +o histexpand

# >>> variables declaration!
readonly version='1.1.0'
readonly script="`basename "$0"`"
readonly uid="${UID:-`id -u`}"
readonly user="`id -un "${uid/#0/1000}"`"
readonly home="/home/$user"

TODO_FILE="$home/Documents/annotations/.todo-list.txt"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Send notification to desktop to remind todo list.

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
# cron: 0 * * * * export DISPLAY=:0; /usr/local/bin/pk/tn 2>/tmp/cron_error.log

[ -s "$TODO_FILE" ] && notify-send '>>> ToDo List!' "$(< "$TODO_FILE")"
