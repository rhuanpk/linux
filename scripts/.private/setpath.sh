#!/usr/bin/bash

# >>> variables declaration
readonly version='2.1.0'
readonly script="$(basename "$0")"
readonly uid="${UID:-$(id -u)}"

# >>> functions declaration
usage() {
cat << EOF
$script v$version

DESCRIPTION
	Setup the given preseted "path flag" and return their atual path is OS.

	Atual supported flags:
		- linux
		- scripts
		- cfg-bkp
		- notes

USAGE
	$script [<options>]

OPTIONS
	-p
		Only prints the path, not save or edit nothing.
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
		echo "$script: error: run as root"
		exit 1
	elif ! "${flag_sudo:-false}"; then
		if "${flag_root:-false}" || [ "$uid" -eq 0 ]; then
			unset sudo
		fi
	fi
}

# >>> pre statements
privileges

while getopts 'psrvh' option; do
	case "$option" in
		p) flag_print=true;;
		s) privileges true false;;
		r) privileges false true;;
		v) echo "$version"; exit 0;;
		h) usage; exit 1;;
		*) exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
setpath() {
	variable="${1:?'need a variable to set'}"
	folder="${2:?'need the name of folder'}"
        environment='/etc/environment'
	path=$(
		find "$HOME/" -type f -name ".$folder.pf" 2>&- \
		| xargs dirname 2>&- \
		| tail -1
	)
	if ! "${flag_print:-false}"; then
		if ! grep -qE -m 1 "^$variable=.*$" "$environment"; then
			$sudo tee -a "$environment" <<< "$variable=$path" &>/dev/null
		else
			$sudo sed -Ei "/^$variable=.*$/s~[^=]+$~$path~" "$environment" 2>&-
		fi
	fi
	echo "$path"
}

declare -A paths=(
	['linux']='PATH_LINUX'
	['scripts']='PATH_SCRIPTS'
	['cfg-bkp']='PATH_CFGBKP'
	['notes']='PATH_NOTES'
)

for folder in "${1:-${!paths[@]}}"; do
	variable="${paths[$folder]}"
	[ -z "$variable" ] && exit 1
	setpath "$variable" "$folder"
done
