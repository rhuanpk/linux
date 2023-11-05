#!/usr/bin/bash

# Tira prints com o scrot e já manda pro diretório correto.

# >>> variable declaration!
readonly version='1.0.0'
script="`basename "$0"`"

# >>> function declaration!
usage() {
cat << EOF
$script v$version

Printscreen with scrot utility and sends to \`~/Pictures/screenshots/\` folders if exists.
Moreover sends to clipboard too.

Usage: $script [<options>] [<delay>]

Options:
	<delay>: Time delay before start printing;
	-s: Area select;
	-p: Show pointer in printscreen;
	-v: Print version;
	-h: Print this help.
EOF
}

is-integer() {
	[[ "$1" =~ ^[0-9]+$ ]] && return 0 || return 1
}

# >>> pre statements!
while getopts 'spvh' OPTION; do
	case "$OPTION" in
		s) ARGS_ARR+='-s -f ';;
		p) ARGS_ARR+='-p ';;
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))


# ***** PROGRAM START *****
# scrot -d 1 -s -p -e 'xclip -selection clipboard -target image/png $f'
cd /tmp

if `is-integer $1` && [ "${1:-0}" -gt 0 ]; then
	ARGS_ARR+="-d $1 "
else
	sleep .25
fi

scrot \
	$ARGS_ARR \
	-e 'xclip -selection clipboard -target image/png $f'

mv /tmp/*scrot.png ~/Pictures/screenshots/
