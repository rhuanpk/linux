#!/usr/bin/bash

# >>> variables declaration
readonly version='1.1.0'
readonly script="$(basename "$0")"
readonly uid="${UID:-$(id -u)}"

# >>> functions declaration
usage() {
cat << EOF
$script v$version

DESCRIPTION
	Clean-up (exclude) all broken symlinks in folder.

USAGE
	$script [<options>]

OPTIONS
	-p <path>
		Specify path where are symlinks (default is current directory).
	-v
		Print version.
	-h
		Print this help.
EOF
}

# >>> pre statements
while getopts 'p:vh' option; do
	case "$option" in
		p) path="$OPTARG";;
		v) echo "$version"; exit 0;;
		h) usage; exit 1;;
		*) exit 2;;
	esac
done
shift $((OPTIND-1))

# ***** PROGRAM START *****
find "${path:-$(pwd)}" -xtype l -exec rm -fv '{}' \;
