#!/usr/bin/bash

# Use `mkdir` and return the path (that was created or that already exists).

# >>> variables declaration!
readonly version='1.0.0'
readonly script="`basename "$0"`"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Use \`mkdir\` and return the path (that was created or that already exists).

Usage: $script [<options>] /path/to/folder

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
PATHSPEC=${1:?need a pathway to create}
[[ "$PATHSPEC" =~ / ]] && {
	echo "$SCRIPT: pathway cannot have depth!"
	exit 2
}
mkdir -v "$PATHSPEC" 2>&1 | sed -nE "s~^.*['‘](.*)['’].*$~\1~p"
