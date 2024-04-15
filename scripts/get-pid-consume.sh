#!/usr/bin/bash

# Get the RSS in MB from a by click.

# >>> variables declaration!
readonly version='1.0.0'
readonly script="$(basename "$0")"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Get de memory (RSS) consume of a PID by clicking in the GUI (if \`-p' option is not present).

Usage: $script [<options>]

Options:
	-p <pid>: PID process;
	-v: Print version;
	-h: Print this help.
EOF
}

# >>> pre statements!
while getopts 'p:vh' option; do
	case "$option" in
		p) pid="$OPTARG";;
		v) echo "$version"; exit 0;;
		h) usage; exit 1;;
		*) exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
[ -z "$pid" ] && pid="$(xprop -f _NET_WM_PID 32i ':$0\n' -notype _NET_WM_PID | cut -d':' -f2)"
kb="$(sed -nE 's/^VmRSS:[[:blank:]]+([[:digit:]]+) kB$/\1/p' /proc/$pid/status)"
echo "$(bc <<< "scale=2; $kb/1024") MB"
