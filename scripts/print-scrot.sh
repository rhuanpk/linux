#!/usr/bin/bash

# Tira prints com o scrot e já manda pro diretório correto.

# >>> variables declaration!
readonly version='1.1.0'
readonly script="`basename "$0"`"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Printscreen with scrot utility and sends to \`~/Pictures/screenshots/\` folders if exists.
Moreover sends to clipboard too.

Pass the standard scrot options normally. Only the -d option that must be pass only the delay value in first argument.

Usage: $script [<delay>] [<scrot-options>]

Options:
	<delay>: Time delay before start printing;
	-v: Print version;
	-h: Print this help.
EOF
}


# >>> pre statements!
case "$1" in
	-v) echo "$version"; exit 0;;
	-h) usage; exit 2;;
esac

# ***** PROGRAM START *****
# scrot -d 1 -s -p -f -e 'xclip -selection clipboard -target image/png $f'
cd /tmp
if [[ "$1" =~ ^(\.?[0-9]+\.?)+$ ]]; then
	#ARGS_ARR+="-d $1 "
	sleep "$1"
	shift
else
	sleep .25
fi
scrot \
	$ARGS_ARR \
	$* \
	-e 'xclip -selection clipboard -target image/png $f' \
&& mv /tmp/*scrot.png ~/Pictures/screenshots/
