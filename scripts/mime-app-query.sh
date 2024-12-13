#!/usr/bin/bash

# >>> built-in setups!
set +o histexpand

# >>> variables declaration!
readonly version='1.0.0'
readonly script="$(basename "$0")"
readonly uid="${UID:-$(id -u)}"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

DESCRIPTION
	Generates a files with all mime types and yours default applications.

USAGE
	$script [<options>]

OPTIONS
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
	get_pm_cmd() {
		which -s apk && { echo 'apk add'; return; }
		which -s apt && { echo 'apt install'; return; }
		which -s dnf && { echo 'dnf install'; return; }
		which -s yum && { echo 'yum install'; return; }
		which -s pkg && { echo 'pkg install'; return; }
		which -s pacman && { echo 'pacman -S'; return; }
		which -s emerge && { echo 'emerge -av'; return; }
		which -s zypper && { echo 'zypper install'; return; }
		which -s portage && { echo 'portage install'; return; }
	}
	privileges
	local packages=('xdg-utils')
	for package in "${packages[@]}"; do
		if ! dpkg -s "$package" &>/dev/null; then
			echo -ne "$script: ask: needed \"$package\", "
			read -rp  "install? [Y/n] "
			[ -z "$REPLY" ] || [ 'y' = "${REPLY,,}" ] && {
				$sudo `get_pm_cmd` "$package" || exit $?
			}
		fi
	done
}

# >>> pre statements!
check-needs

while getopts 'vh' option; do
	case "$option" in
		v) echo "$version"; exit 0;;
		h) usage; exit 1;;
		*) exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
readonly file_mimes='/usr/share/mime/types'
readonly file_query="/tmp/$(mktemp mime-app_XXXXXXX.txt)"
while read mime; do
	app="$(xdg-mime query default $mime)"
	tee -a "$file_query" <<< "$mime: ${app:-null}"
done < "$file_mimes"
echo "$script: generated mime app query in: $file_query"
