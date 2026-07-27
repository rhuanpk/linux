#!/usr/bin/bash

# >>> variables declaration
readonly version='2.2.0'
readonly script="$(basename "$0")"
readonly uid="${UID:-$(id -u)}"

# >>> functions declaration
usage() {
cat << EOF
$script v$version

DESCRIPTION
	Setup the given preseted "path flag" and return their atual path is OS.

	Atual supported flags:
		- linux (\$PATH_LINUX)
		- scripts (\$PATH_SCRIPTS)
		- cfgbkp (\$PATH_CFGBKP)
		- notes (\$PATH_NOTES)

USAGE
	$script [<options>] [<flag>]

OPTIONS
	-p
		Only prints the path, not save or edit nothing.
	-v
		Print version.
	-h
		Print this help.
EOF
}

# >>> pre statements
while getopts 'pvh' option; do
	case "$option" in
		p) flag_print=true;;
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
        environment="$HOME/.profile"
	path=$(
		find "$HOME/" -type f -name ".$folder.pf" 2>&- \
		| xargs dirname 2>&- \
		| tail -1
	)
	if ! "${flag_print:-false}"; then
		if ! grep -qE -m 1 "^$variable=.*$" "$environment" 2>&-; then
			tee -a "$environment" <<< "$variable=$path" &>/dev/null
		else
			sed -Ei "/^$variable=.*$/s~[^=]*$~$path~" "$environment" 2>&-
		fi
	fi
	[ "$path" ] && echo "$path"
}

declare -A paths=(
	['linux']='PATH_LINUX'
	['scripts']='PATH_SCRIPTS'
	['cfgbkp']='PATH_CFGBKP'
	['notes']='PATH_NOTES'
)

for folder in "${1:-${!paths[@]}}"; do
	variable="${paths[$folder]}"
	[ -z "$variable" ] && exit 1
	setpath "$variable" "$folder"
done
