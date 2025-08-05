#!/usr/bin/bash

# >>> variables declaration
readonly version='1.0.0'
readonly script="$(basename "$0")"

# >>> functions declaration
usage() {
cat << EOF
$script v$version

DESCRIPTION
	Make the autostart files from given (<name>:<basename>) binaries.

USAGE
	$script [<options>] CopyQ:copyq Flameshot:flameshot LocaSend:localsend_app pCloud:pcloud

OPTIONS
	-v
		Print version.
	-h
		Print this help.
EOF
}

# >>> pre statements
while getopts 'vh' option; do
	case "$option" in
		v) echo "$version"; exit 0;;
		h) usage; exit 1;;
		*) exit 2;;
	esac
done
shift $((OPTIND-1))

# ***** PROGRAM START *****
path_autostart=~/.config/autostart

[ ! -d "$path_autostart/" ] && mkdir -pv "$path_autostart/"

index=1
for arg; do
	name="${arg/:*}"
	bin="${arg/*:}"
	file="$path_autostart/$bin.desktop"
	echo "$file:"
	tee "$file" <<- EOF
		[Desktop Entry]
		Type=Application
		Name=$name
		TryExec=$bin
		Exec=$bin
		Terminal=false
	EOF
	((index < $#)) && echo
	let index++
done
