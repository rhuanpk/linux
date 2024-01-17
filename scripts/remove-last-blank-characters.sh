#!/usr/bin/bash

# Remove Last Clank character remove thats in all lines in file passed like argument.

# >>> variables declaration!
readonly version='2.0.0'
readonly script="`basename "$0"`"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Remove Last Blank Character (rlbc) remove thats in all lines in passed file like argument.

Usage: $script [<options>] /path/to/file-text.any ['/path/to/other/file text.any' ...]

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
[ "$#" -lt 1 ] && echo "$script: need one or more files to run"
for file; do
	if ! sed -Ei 's/[[:blank:]]+$//g' "$file"; then
		echo "$script: error in \"$file\""
	fi
done
