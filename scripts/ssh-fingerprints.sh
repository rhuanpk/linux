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
for pub in $HOME/.ssh/*.pub; do
	echo "key → $pub:"
	ssh-keygen -lf $pub
done
