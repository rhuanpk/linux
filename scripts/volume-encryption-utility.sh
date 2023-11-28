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
VOLUME_PATH='/tmp/private'

# >>> function declaration!
usage() {
cat << EOF
$script v$version

Its a volume encryption utility (a bash script with simple instructions).

Usage: $script [<options>]

Options:
	-t: Print status of volume;
	-p </path/to/folder>: Set as new folder to used like the volume;
	-m: Mount the volume;
	-u: Umount the volume;
	-s: Forces keep sudo;
	-r: Forces unset sudo;
	-v: Print version;
	-h: Print this help.
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

check-needs() {
	PACKAGES=('ecryptfs-utils')
	for package in "${PACKAGES[@]}"; do
		if ! dpkg -s "$package" &>/dev/null; then
			read -p "$script: this script needs the \"$package\" package but not installed, install this? [Y/n] " answer
			[ -z "$answer" ] || [ 'y' = "${answer,,}" ] && $SUDO apt install -y "$package"
		fi
	done
}

change-path() {
	NEW_PATH="${1:?need a path to set new mount point}"
	LINE_AND_PATH=`grep -nE '^VOLUME_PATH=.*$' "$location"`
	OUTPUT=$($SUDO sed -i "${LINE_AND_PATH%:*}s~${LINE_AND_PATH#*=}~'`realpath ${NEW_PATH/%\//}`'~" "$location" 2>&1)
	RETURN="$?"
	default-message "$RETURN" 'changing path of private folder' "$OUTPUT"
	exit "$RETURN"
}

mount-private() {
	if is-mounted; then
		echo "$script: \"$VOLUME_PATH/\" already mounted"
		exit 0
	fi
	[ ! -d "$VOLUME_PATH/" ] && {
		OUTPUT=$(
			mkdir -p "$VOLUME_PATH/" \
			&& chmod 600 "$VOLUME_PATH/" \
			&& $SUDO mount \
				--types ecryptfs \
				"$VOLUME_PATH/" "$VOLUME_PATH/" \
			3>&1 1>&2 2>&3
		)
	} || {
		# ecryptfs_enable_filename_crypto=yes
		OUTPUT=$(
			$SUDO mount \
				--types ecryptfs \
				--options \
					key=passphrase,ecryptfs_cipher=aes,ecryptfs_key_bytes=32,ecryptfs_passthrough=no \
				"$VOLUME_PATH/" "$VOLUME_PATH/" \
			3>&1 1>&2 2>&3
		)
	}
	RETURN="$?"
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
check-needs

while getopts 'tp:musrvh' option; do
	case "$option" in
		t) print-status; exit 0;;
		p) change-path "$OPTARG";;
		m) mount-private;;
		u) umount-private;;
		s) privileges true false;;
		r) privileges false true;;
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
