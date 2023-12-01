#!/usr/bin/bash

# Volume Encryption Utility (VEU).

# >>> built-in sets!
set +o histexpand

# >>> variable declaration!
readonly version='1.2.0'
location="`realpath "$0"`"
script="`basename "$0"`"
uid="${UID:-`id -u`}"

SUDO='sudo'
VOLUME_PATH='/tmp/.private'
ECRYPTFS_BYTES=
ECRYPTFS_CIPHER=
ECRYPTFS_SIGNATURE=
ECRYPTFS_FNEK=

# >>> function declaration!
usage() {
cat << EOF
$script v$version

This script it is a simple volume encryption utility (a bash script with simple instructions).

Usage: $script [<options>]

Options:
	-t: Print status of volume;
	-m: Mount the volume;
	-u: Umount the volume;
	-c: Configure variables;
	-s: Forces keep sudo;
	-r: Forces unset sudo;
	-v: Print version;
	-h: Print this help.

	-p </path/to/folder>: Set a new folder to used like the volume.
EOF
}

print-status() {
	cat <<- eof
		Current folder setuped: "$VOLUME_PATH/"
		Is-mounted: `if is-mounted; then echo true; else echo false; fi`
	eof
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

check-needs() {
	PACKAGES=('ecryptfs-utils')
	for package in "${PACKAGES[@]}"; do
		if ! dpkg -s "$package" &>/dev/null; then
			read -p "$script: this script needs the \"$package\" package but not installed, install this? [Y/n] " answer
			[ -z "$answer" ] || [ 'y' = "${answer,,}" ] && $SUDO apt install -y "$package"
		fi
	done
}

default-message() {
	RETURN="${1:?needs a code to verify}"
	OPERATION="${2:?needs a message to show}"
	OUTPUT="$3"
	[ "$RETURN" -eq 0 ] && {
		echo "$script: success on $OPERATION"
	} || {
		echo -e "$script: failed on $OPERATION:\n$OUTPUT"
	}
}

set-variable() {
	VARIABLE_NAME="${1:?need a variable to change}"
	NEW_VALUE="${2:?need a path to set new mount point}"
	IS_PATH="$3"
	if "${IS_PATH:-false}"; then
		NEW_VALUE="`realpath ${NEW_VALUE/%\//}`"
	fi
	LINE_AND_PATH=`grep -nE "^$VARIABLE_NAME=.*$" "$location"`
	OUTPUT=$($SUDO sed -i "${LINE_AND_PATH%:*}s~${LINE_AND_PATH#*=}$~'$NEW_VALUE'~" "$location" 2>&1)
	RETURN="$?"
	default-message "$RETURN" 'changing path of private folder' "$OUTPUT"
	exit "$RETURN"
}

setup-variables() {
	IS_RECONFIG="${1:?need a bool to know if are reconfig}"
	echo "$script: entering into variables setup!"
	for config in \
		'ECRYPTFS_CIPHER' \
		'ECRYPTFS_BYTES' \
		'ECRYPTFS_SIGNATURE' \
		'ECRYPTFS_FNEK'; \
	do
		MESSAGE="$script (setup) - $config"
		[ "$config" = 'ECRYPTFS_FNEK' ] && MESSAGE+=' (empty if not set)'
		MESSAGE+=': '
		if "$IS_RECONFIG"; then
			OPTIONS="-i '$(eval echo \$$config)'"
		fi
		read $OPTIONS -ep "$MESSAGE" answer
		set-variable "$config" "$answer"
	done
}

mount-private() {
	check-needs
	if is-mounted; then
		echo "$script: \"$VOLUME_PATH/\" already mounted"
		exit 0
	fi
	if [ ! -d "$VOLUME_PATH/" ]; then
		OUTPUT=$(
			mkdir -p "$VOLUME_PATH/" \
			&& chmod 600 "$VOLUME_PATH/" \
			&& $SUDO mount \
				--types ecryptfs \
				"$VOLUME_PATH/" "$VOLUME_PATH/" \
			3>&1 1>&2 2>&3
		)
		RETURN="$?"
		if [ "$RETURN" -ne 0 ]; then
			rmdir "$VOLUME_PATH/"
		else
			setup-variables false
		fi
	else
		OPTIONS=(
			'key=passphrase'
			'ecryptfs_unlink_sigs'
			"ecryptfs_key_bytes=$ECRYPTFS_BYTES"
			"ecryptfs_cipher=$ECRYPTFS_CIPHER"
			"ecryptfs_sig=$ECRYPTFS_SIGNATURE"
			'ecryptfs_passthrough=no'
		)
		[ -n "$ECRYPTFS_FNEK" ] && OPTIONS+=(
			"ecryptfs_fnek_sig=$ECRYPTFS_FNEK"
			'ecryptfs_enable_filename_crypto=yes'
		)
		OUTPUT=$(
			$SUDO mount \
				--types ecryptfs \
				--options "`IFS=,; echo "${OPTIONS[*]}"`" \
				"$VOLUME_PATH/" "$VOLUME_PATH/" \
			3>&1 1>&2 2>&3
		)
		RETURN="$?"
	fi
	default-message "$RETURN" 'mounting private folder' "$OUTPUT"
	exit "$RETURN"
}

umount-private() {
	if ! is-mounted; then
		echo "$script: \"$VOLUME_PATH/\" already unmounted"
		exit 0
	fi
	OUTPUT=`$SUDO umount "$VOLUME_PATH/" 2>&1`
	RETURN="$?"
	default-message "$RETURN" 'unmounting private folder' "$OUTPUT"
	exit "$RETURN"
}

is-mounted() { mountpoint "$VOLUME_PATH/" &>/dev/null; }

# >>> pre statements!
privileges false false
while getopts 'tp:mucsrvh' option; do
	case "$option" in
		t) print-status; exit 0;;
		p) set-variable 'VOLUME_PATH' "$OPTARG" true;;
		m) mount-private;;
		u) umount-private;;
		c) setup-variables true;;
		s) privileges true false;;
		r) privileges false true;;
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
