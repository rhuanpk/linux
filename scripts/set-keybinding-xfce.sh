#!/usr/bin/bash

# Reset and set as new keybing for xfce environments.

# >>> variables declaration!
readonly version='1.1.0'
readonly script="`basename "$0"`"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Set a new binding passing the following params for xfce systems:
	1. Binding;
	2. Command.

Usage:
	$script [<options>] '<Alt>v' volume-control.sh

Options:
	-v: Print version;
	-h: Print this help.

Observations:
	1. To remove the binding only pass the first param.
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
xfconf-query --reset --channel xfce4-keyboard-shortcuts --property "/xfwm4/custom/$1"
xfconf-query --reset --channel xfce4-keyboard-shortcuts --property "/commands/custom/$1"
[ "$#" -ge '2' ] && xfconf-query --create --channel xfce4-keyboard-shortcuts --property "/commands/custom/$1" --type string --set "$2"
