#!/usr/bin/env bash

# Volume Encryption Utility (veu).

# >>> variable declarations !

script=$(basename "${0}")
home=${HOME:-/home/${USER:-$(whoami)}}

# >>> function declarations !

verify_privileges() {
	[ $UID -eq 0 ] && {
		echo -e "ERROR: Run this program without privileges!\nExiting..."
		exit 1
	}
}

print_usage() {
	cat <<- eof
		###########################################################################
		#
		# >>> ${script} !
		#
		# Its a volume encryption utility (a bash script with simple instructions).
		#
		# OPTIONS:
		#
		# 	-h: print usage and exit.
		# 	-s: print status of volume.
		# 	-p </path/to/folder>: set as new folder to used like the volume.
		# 	-m: mount the volume.
		# 	-u: umount the volume.
		#
		###########################################################################
	eof
}

# >>> pre statements !

set +o histexpand

verify_privileges
[ ${#} -lt 1 ] && {
        print_usage
        exit 1
}

# >>> *** PROGRAM START *** !

volume_path=/tmp/tmp/private
script_name=$0

is_mounted_status=$(
	if mountpoint ${volume_path}/ &>/dev/null; then
		echo true
	else
		echo false
	fi
)

print_status() {	
	cat <<- eof
		current folder set: $volume_path/
		is-mounted: $is_mounted_status
	eof
}

change_path() {
	new_path=${1:?'need a path to set new mount point!'}
	script_path=$(which ${script_name})
	line_and_path=$(grep -nE '^(volume_path=).*$' ${script_path:?'path of script not set!'})
	if ! sudo sed -i "${line_and_path%:*}s~${line_and_path#*=}~${new_path}~" ${script_path}; then
		echo 'Failed on changing!'
		exit 1
	else
		echo 'Successful on changing!'
		exit 0
	fi
}

mount_private() {
	try_mount() {
		y_command=$1
		if ! error_message=$(eval "${y_command}" 3>&1 1>&2 2>&3); then
			cat <<- eof
				Failed on mounting! ${error_message:+$(echo -e "\nerror message: ${error_message}")}
			eof
			exit 1
		else
			echo 'Successful on mounting!'
			exit 0
		fi
	}
	if $is_mounted_status; then
		echo "${volume_path} already mounted!"
		exit 1
	fi
	[ ! -d ${volume_path}/ ] && {
		try_mount 'mkdir -p ${volume_path}/ && chmod 0600 ${volume_path}/ && sudo mount -t ecryptfs ${volume_path}/ ${volume_path}/'
	} || {
		try_mount 'sudo mount -t ecryptfs ${volume_path}/ ${volume_path}/ -o key=passphrase,ecryptfs_cipher=aes,ecryptfs_key_bytes=32,ecryptfs_passthrough=n'
	}
}

umount_private() {
	if ! $is_mounted_status; then
		echo "${volume_path} already unmounted!"
		exit 1
	fi
	if ! error_message=$(sudo umount $volume_path); then
		cat <<- eof
			Failed on mounting! ${error_message:+$(echo -e "\nerror message: ${error_message}")}
		eof
		exit 1
	else
		echo 'Successful on umounting!'
		exit 0
	fi
}

check_needs() {
	y_package=ecryptfs-utils
	if ! dpkg -s ${y_package} &>/dev/null; then
		read -rp "this script needs the ${y_package} package but not installed, install this? [Y/n] " answer
		[ -z $answer ] || [ 'y' = ${answer,,} ] && sudo apt install $y_package -y
	fi
}

check_needs
while getopts 'hsp:mu' opt; do
	case $opt in
		h) print_usage; exit 0;;
		s) print_status; exit 0;;
		p) change_path ${OPTARG};;
		m) mount_private;;
		u) umount_private;;
		?) print_usage; exit 1;;
	esac
done
