#!/usr/bin/bash

# Recorde a screen area as gif image.

# >>> variables declaration!
readonly version='1.0.0'
readonly script="`basename "$0"`"
readonly uid="${UID:-`id -u`}"

SUDO='sudo'
FILE="$(mktemp /tmp/byzanz-XXXXXXX-`date '+%F_%T'`.gif)"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Recorde a screen area as gif image.

Usage: $script [<options>]

Options:
	-c: Record the cursor;
	-d <seconds>: Record duration (default is 10s);
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

check-needs() {
	privileges false false
	PACKAGES=('slop' 'byzanz' 'xclip' 'libnotify-bin')
	for package in "${PACKAGES[@]}"; do
		if ! dpkg -s "$package" &>/dev/null; then
			read -p "$script: is needed the \"$package\" package, install? [Y/n] " answer
			[ -z "$answer" ] || [ 'y' = "${answer,,}" ] && $SUDO apt install -y "$package"
		fi
	done
}

# >>> pre statements!
check-needs

while getopts 'cd:vh' option; do
	case "$option" in
		c) OPTIONS+=' -c';;
		d) OPTIONS+=" -d $OPTARG";;
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
if pgrep -f ffmpeg >/dev/null; then
	echo "$script: warning: \"ffmpeg\" is running, byzanz maybe fail"
fi
read -r XAXIS YAXIS WIDTH HEIGHT < <(slop -qf '%x %y %w %h')
byzanz-record -x "$XAXIS" -y "$YAXIS" -w "$WIDTH" -h "$HEIGHT" "$FILE" $OPTIONS
notify-send "${script^} (script) - DONE!" "You gif already in your clipboard and:\n$FILE"
xclip -sel clip -rmlastnl <<< "$FILE"
echo "$script: file: \"$FILE\"."
