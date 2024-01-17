#!/usr/bin/bash

# Create an jail example and itself move there.

# >>> variables declaration!
readonly version='1.0.0'
readonly script="`basename "$0"`"
readonly uid="${UID:-`id -u`}"

SUDO='sudo'

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Make a jail and move it.

Usage: $script [<options>] [/path/to/tmp/jail]

Options:
	-s: Forces keep sudo;
	-r: Forces unset sudo;
	-v: Print version;
	-h: Print this help.
EOF
}

privileges() {
	FLAG_SUDO="${1:?needs sudo flag}"
	FLAG_ROOT="${2:?needs root flag}"
	if [[ -z "$SUDO" && "$uid" -ne 0 ]]; then
		echo "$script: run with root privileges"
		exit 1
	elif ! "$FLAG_SUDO"; then
		if "$FLAG_ROOT" || [ "$uid" -eq 0 ]; then
			unset SUDO
		fi
	fi
}

# >>> pre statements!
while getopts 'srvh' option; do
	case "$option" in
		s) privileges true false;;
		r) privileges false true;;
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

privileges false false

# ***** PROGRAM START *****
JAIL_PATH=${1:-/tmp/jail}
[ -d $JAIL_PATH/ ] && rm -rf $JAIL_PATH/
mkdir -p $JAIL_PATH/{lib/x86_64-linux-gnu/,lib64/,usr/bin/}
cp /usr/bin/{bash,ls} $JAIL_PATH/usr/bin/
cp /lib/x86_64-linux-gnu/{libselinux.so.1,libc.so.6,libpcre2-8.so.0,libtinfo.so.6} $JAIL_PATH/lib/x86_64-linux-gnu/
cp /lib64/ld-linux-x86-64.so.2 $JAIL_PATH/lib64/
$SUDO chroot $JAIL_PATH/ /usr/bin/bash
