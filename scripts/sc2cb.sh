#!/usr/bin/bash

# Send Color To ClipBoard sends the hex code of the color to your clipboard.

# >>> built-in setups!
set -eo pipefail +o histexpand

# >>> variables declaration!
readonly version='1.2.0'
readonly script="$(basename "$0")"
readonly uid="${UID:-$(id -u)}"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

DESCRIPTION
	Sends the hex code of the color to your clipboard.

USAGE
	$script [<options>]

OPTIONS
	-s
		Forces keep sudo.
	-r
		Forces unset sudo.
	-v
		Print version.
	-h
		Print this help.
EOF
}

privileges() {
	local flag_sudo="$1"
	local flag_root="$2"
	sudo='sudo'
	if [[ -z "$sudo" && "$uid" -ne 0 ]]; then
		echo "$script: error: run as root #sudo"
		exit 1
	elif ! "${flag_sudo:-false}"; then
		if "${flag_root:-false}" || [ "$uid" -eq 0 ]; then
			unset sudo
		fi
	fi
}

check-needs() {
	privileges
	local packages=('xclip')
	for package in "${packages[@]}"; do
		if ! dpkg -s "$package" &>/dev/null; then
			echo -ne "$script: ask: needed \"$package\", "
			read -rp  "install? [Y/n] "
			[ -z "$REPLY" ] || [ 'y' = "${REPLY,,}" ] && {
				$sudo apt install -y "$package"
			}
		fi
	done
	if ! which -s 'colorpicker'; then
		#local file_url='https://raw.githubusercontent.com/rhuanpk/misc/main/binaries/colorpicker'
		#local folder2save='/usr/local/bin'
		#local filename='colorpicker'
		#$sudo wget -P "$folder2save/" "$file_url"
		#$sudo chmod +x "$folder2save/$filename"
		echo "$script: error: need to install \`colorpicker': https://github.com/Jack12816/colorpicker"
	fi
}

# >>> pre statements!
privileges
check-needs

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
colorpicker --one-shot --short | xclip -sel clip -rmlastnl
