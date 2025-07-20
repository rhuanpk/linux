#!/usr/bin/bash

# Use `mkdir` and return the path (that was created or that already exists).

# >>> variables declaration!
readonly version='1.1.0'
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
while getopts 'vh' option; do
	case "$option" in
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
pathspec=${1:?need a pathway to create}
[[ "$pathspec" =~ / ]] && {
	echo "$script: pathway cannot have depth!"
	exit 2
}
mkdir -v "$pathspec" 2>&1 | sed -nE "s~^.*['‘](.*)['’].*$~\1~p"
