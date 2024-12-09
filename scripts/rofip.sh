#!/usr/bin/bash

# My custom rofi.

# >>> variables declaration!
readonly version='1.0.0'
readonly script="`basename "$0"`"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Custom rofi.

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
path="$PK_LOAD_CFGBKP"
#rofi -modi 'drun,run,window,emoji:~/.local/bin/rofi/emoji' -show drun -window-format '{w} - {c} * {t}'
rofi -modi "drun,run,window,emoji:$path/rofi/emoji" -show drun -window-format '{w} - {c} * {t}'
