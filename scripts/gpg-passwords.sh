#!/usr/bin/bash

# Change password of gpg files in batch.

# >>> variables declaration!
readonly version='1.0.0'
readonly script="`basename "$0"`"
readonly uid="${UID:-`id -u`}"

SUDO='sudo'

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Automate change password of gpg symmetric encrypted files (with the same password).

Usage: $script [<options>]

Options:
	-d: Specify direcoty within gpg files (otherwise \`pwd\` is default);
	-v: Print version;
	-h: Print this help.
EOF
}

privileges() {
	FLAG_SUDO="${1:?needs sudo flag}"
	FLAG_ROOT="${2:?needs root flag}"
	if [[ -z "$SUDO" && "$uid" -ne 0 ]]; then
		echo "$script: error: run with root privileges"
		exit 1
	elif ! "$FLAG_SUDO"; then
		if "$FLAG_ROOT" || [ "$uid" -eq 0 ]; then
			unset SUDO
		fi
	fi
}

check-needs() {
	privileges false false
	PACKAGES=('gpg')
	for package in "${PACKAGES[@]}"; do
		if ! dpkg -s "$package" &>/dev/null; then
			read -p "$script: info: is needed the \"$package\" package, install? [Y/n] " answer
			[ -z "$answer" ] || [ 'y' = "${answer,,}" ] && $SUDO apt install -y "$package"
		fi
	done
}

# >>> pre statements!
check-needs

while getopts 'd:vh' option; do
	case "$option" in
		d) PATHWAY="${OPTARG%/}";;
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
echo -e "$script (Change GPG Passwords) v$version\n\nChanging password of gpg files in \"${PATHWAY:=`pwd`}\"!\n"
read -sp "OLD password: " OLD_PASSWD; echo
read -sp "NEW password: " NEW_PASSWD; echo
for file in $(ls "$PATHWAY/"{,.}*.gpg 2>&-); do
	echo -e "\n- ATUAL FILE: \"`basename "$file"`\""
	gpg \
		--no-symkey-cache \
		--batch --passphrase-fd 0 \
		--decrypt \
		--output "${file%.gpg}" \
		"$file" \
		<<< "$OLD_PASSWD" \
	&& rm -fv "$file" \
	&& gpg \
		--no-symkey-cache \
		--batch --passphrase-fd 0 \
		--symmetric "${file%.gpg}" \
		<<< "$NEW_PASSWD" \
	&& rm -fv "${file%.gpg}" \
	&& echo 'Done: SUCCESS!' || echo 'Done: FAILURE!'
done
