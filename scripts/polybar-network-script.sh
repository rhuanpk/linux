#!/usr/bin/bash

# Prints the local ip for polybar module.

# >>> variables declaration!
readonly version='1.0.0'
readonly script="`basename "$0"`"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Prints the local ip for polybar module.

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
INTERFACE="`ip a | grep -FA2 'state UP'`"
IP="`sed -nE 's/^.*inet (([[:digit:]]{1,3}.?){4})\/.*$/\1/p' <<< "$INTERFACE"`"
[ -n "$INTERFACE" ] && {
	if [ "`wc -l < /proc/net/wireless`" -gt 2 ]; then
		TYPE='w_IP'
	else
		TYPE='e_IP'
	fi
} || TYPE='Network'
[ -z "$IP" ] && IP='N/A'
if pvs; then
	IP+=' (VPN)'
fi
echo "$TYPE: $IP |"
