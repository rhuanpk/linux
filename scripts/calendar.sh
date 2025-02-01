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
	-v
		Print version.
	-h
		Print this help.
EOF
}

# >>> pre statements
while getopts 'vh' option; do
	case "$option" in
		v) echo "$version"; exit 0;;
		h) usage; exit 1;;
		*) exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
while IFS= read; do
	local output="$(printf '%*s%s' "$(((`tput cols`-64)/2))" '' "$REPLY")"
	echo "$output"
done <<< "`ncal -by`"
