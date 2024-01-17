#!/usr/bin/bash

# Take the Window (TK).
# It is software that gives focus to the specified window or executes a command if it is not available.

# >>> variables declaration!
readonly version='1.1.0'
readonly script="`basename "$0"`"

CLASS_SEARCH="${1:?'need a classe to search, e.g. "x-terminal-emulator", "X-terminal-emulator"'}"
COMMAND_EXECUTE="${2:?'need a command to execute case the window dont visible, e.g. xdotool key --clearmodifiers Control_L+t'}"

ID_LIST="$(xprop -root | sed -nE 's/^_NET_CLIENT_LIST_STACKING\(WINDOW\): window id # (.*)$/\1/p;s/,//')"
IS_VISIBLE='false'
SED_COMMAND='sed -nE "s/^WM_CLASS\(STRING\) = (.*)/\1/p"'

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Take a window and execute a command.

Syntax:
	$script <window-class> <command-to-execute>

Usage:
	$script [<options>] '"google-chrome", "Google-chrome"' 'xdotool --clearmodifiers Alt_L+F4'

Options:
	-v: Print version;
	-h: Print this help.

Tip/Trick:
	Usually the names placed in <window_class> is the name of the binary and its "formal name",
	sometimes both fields will be the binary name e.g. '"terminator", "terminator"' and
	sometimes both the fields will be the "formal name" e.g. '"DBeaver", "DBeaver"'.
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
echo 'Windows:'
for id in "$ID_LIST"; do
	WINDOW="$(eval "xprop -id '$id' | $SED_COMMAND")"
	[ "$WINDOW" = "$CLASS_SEARCH" ] && IS_VISIBLE='true' && WINDOW_ID="$id"
	echo -e "\t- $WINDOW"
done

if ! "$IS_VISIBLE"; then
	eval "$COMMAND_EXECUTE"
elif [ "$(eval "xprop -id $(xdotool getactivewindow) | $SED_COMMAND")" != "$CLASS_SEARCH" ]; then
	xdotool windowactivate "$WINDOW_ID" 2>&-
fi
