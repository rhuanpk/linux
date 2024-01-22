#!/usr/bin/bash

# Print the fingerprint of ssh public key argument or all in default ~/.ssh/.

# >>> variables declaration!
readonly version='1.1.0'
readonly script="`basename "$0"`"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Print the fingerprint of ssh public key argument or all in default ~/.ssh/.

Usage: $script [<options>]

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
COUNT="`ls -1 ~/.ssh/*.pub | wc -l`"
INDEX='1'
for pub in $HOME/.ssh/*.pub; do
	echo -e "key » `dirname "$pub"`/\033[36m`basename "${pub%.*}"`\033[m.pub:"
	echo -e "- content: $(< "$pub")"
	echo -e "- fingerprint: `ssh-keygen -lf "$pub"`"
	[ "$INDEX" -lt "$COUNT" ] && echo
	let INDEX++
done
