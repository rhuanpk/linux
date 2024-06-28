#!/usr/bin/bash

# Mount usual file system types with options of a file manger mount.

# >>> variables declaration!
readonly version='1.1.0'
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
blkid-extract() {
	local disk="${1:?$FUNCNAME: need a disk to extract infos}"
	local field="${2:?$FUNCNAME: need a field to extract infos}"
	$sudo blkid -o export "$disk" | sed -nE "s/^${field^^}=(.*)$/\1/p" | tr -d '\\'
}
#random() { mktemp -u "${RANDOM//?/X}"; }
disk="${1:?need a disk to mount}"
point="$(blkid-extract "$disk" 'label')"
: ${point:=$(blkid-extract "$disk" 'partlabel')}
: ${point:=$(blkid-extract "$disk" 'partuuid')}
point="/mnt/$point"
[ -d "$point" ] && {
	already="$(df --output='source' "$point/" | sed -n 2p)"
	[ "$(blkid-extract "$disk" 'partuuid')" != "$(blkid-extract "$already" 'partuuid')" ] && {
		point+="-$(blkid-extract "$disk" 'uuid')"
	}
}
if mountpoint -q "$point/"; then
	$sudo umount -v "$point/"
	$sudo rmdir -v "$point/"
else
	$sudo mkdir -pv "$point/"
	case "$(blkid-extract "$disk" 'type')" in
		ext4) options=',nosuid,nodev,errors=remount-ro,uhelper=udisks2';;
		vfat) options=",nosuid,nodev,uid=`id -u`,gid=`id -g`,showexec,flush,uhelper=udisks2";;
		exfat) options=",nosuid,nodev,uid=`id -u`,gid=`id -g`,uhelper=udisks2";;
		ntfs) options=',nosuid,nodev,default_permissions,uhelper=udisks2';;
		iso9660) options=",nosuid,nodev,uid=`id -u`,gid=`id -g`,uhelper=udisks2";;
		*) echo "$script: info: unusual filesystem type";;
	esac
	$sudo mount -vo defaults$options "$disk" "$point/"
fi
