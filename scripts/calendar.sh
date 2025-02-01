#!/usr/bin/bash

# >>> variables declaration
readonly version='1.0.0'
readonly script="$(basename "$0")"

# >>> functions declaration
failure() {
	notify-send "${script^^}" "Failed \"$BASH_COMMAND\"!"
}

#decoy() {}

usage() {
cat << EOF
$script v$version

DESCRIPTION
	Simple shorthand for \`ncal' command.

USAGE
	$script [<options>]

OPTIONS
	-r
		Start a \`read -n1' at end of script.
	-v
		Print version.
	-h
		Print this help.
EOF
}

# >>> pre statements
while getopts 'rvh' option; do
	case "$option" in
		r) flag_read=true;;
		v) echo "$version"; exit 0;;
		h) usage; exit 1;;
		*) exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
while IFS= read; do
	echo "$(printf '%*s%s' "$(((`tput cols`-64)/2))" '' "$REPLY")"
done <<< "`ncal -by`"
test "$flag_read" && read -n1
