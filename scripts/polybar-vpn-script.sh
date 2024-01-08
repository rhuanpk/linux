#!/usr/bin/bash

# Print the CPU usage for polybar module.

# >>> variable declaration!
readonly version='1.0.0'
script="`basename "$0"`"

# >>> function declaration!
usage() {
cat << EOF
$script v$version

Short description of how it works.

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
VALIDATES="tun0|wg0|`hostname`"
if ping -c 1 iana.org &>/dev/null; then
	[[ "`ip -br link | cut -d ' ' -f 1`" =~ ($VALIDATES) ]] && {
		echo '(VPN) |'
	} || {
		echo '|'
	}
else
	echo
fi
