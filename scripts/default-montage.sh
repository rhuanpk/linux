#!/usr/bin/bash

# Mount usual file system types with options of a file manger mount.

# >>> variables declaration!
readonly version='1.0.2'
readonly script="$(basename "$0")"
readonly uid="${UID:-$(id -u)}"

sudo='sudo'

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Mount usual file system types with options of a file manger mount.

Usage: $script [<options>] </dev/sdXY> </path/to/mount/point>

Options:
	-s: Forces keep sudo;
	-r: Forces unset sudo;
	-v: Print version;
	-h: Print this help.
EOF
}

privileges() {
	local flag_sudo="$1"
	local flag_root="$2"
	if [[ -z "$sudo" && "$uid" -ne 0 ]]; then
		echo "$script: error: run with root privileges"
		exit 1
	elif ! "$flag_sudo"; then
		if "$flag_root" || [ "$uid" -eq 0 ]; then
			unset sudo
		fi
	fi
}

# >>> pre statements!
privileges false false

while getopts 'srvh' option; do
	case "$option" in
		s) privileges true false;;
		r) privileges false true;;
		v) echo "$version"; exit 0;;
		h) usage; exit 1;;
		*) exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
disk="${1:?need a disk to mount}"
point="${2:?need a mount point to mount}"
case "$($sudo blkid -o export "$disk" | sed -nE 's/^TYPE=(.*)$/\1/p')" in
	ext4) options=',nosuid,nodev,errors=remount-ro,uhelper=udisks2';;
	vfat) options=",nosuid,nodev,uid=`id -u`,gid=`id -g`,showexec,flush,uhelper=udisks2";;
	exfat) options=",nosuid,nodev,uid=`id -u`,gid=`id -g`,uhelper=udisks2";;
	ntfs) options=',nosuid,nodev,default_permissions,uhelper=udisks2';;
	*) echo "$script: info: unusual filesystem type";;
esac
$sudo mount -o defaults$options "$disk" "$point"
