#!/usr/bin/bash

# OBS: Whenever you add a new function, add it to the "ALL_FUNCTIONS" array.

# >>> built-in sets!
#set -ex +o histexpand

# >>> variable declaration!
readonly version='1.1.0'
script="`basename "$0"`"
uid="${UID:-`id -u`}"

SUDO='sudo'
SETLOAD_URL='https://raw.githubusercontent.com/rhuanpk/linux/main/scripts/.private/setload.sh'
PATHWAY=${PK_LOAD_LINUX:-`wget -qO - "$SETLOAD_URL" | bash - 2>&- | grep linux`}
ALL_FILES=`ls -1 "$PATHWAY"/*.sh`
ALL_FUNCTIONS=('copy2symlink' 'copy2binary')
EXPRESSION='(backup|volume-encryption-utility)\.sh'

# >>> function declaration!
usage() {
cat << EOF
$script v$version

Move binaries to \`/usr/local/bin\` folder converting symlinks but some not.

Usage: $script [<options>]

Options:
	-l: Move only those that will be converted to symlinks;
	-s: Forces keep sudo;
	-r: Forces unset sudo;
	-v: Print version;
	-h: Print this help.
EOF
}

make-shorthand() {
	NAME="`basename "${1%.sh}"`"
	[[ "$NAME" =~ - ]] && tr '-' '\n' <<< "$NAME" | cut -c 1 | tr -d '\n' || echo "$NAME"
}

copy2symlink() {
	for file in `grep -vE "$EXPRESSION" <<< "$ALL_FILES"`; do
		$SUDO ln -sfv "$file" "/usr/local/bin/pk/`make-shorthand "$file"`"
	done
}

copy2binary() {
	for file in `grep -E "$EXPRESSION" <<< "$ALL_FILES"`; do
		$SUDO cp -v "$file" "/usr/local/bin/pk/`make-shorthand "$file"`"
	done
}

execute-all() {
	for func in "${ALL_FUNCTIONS[@]}"; do
		$func
	done
}

# >>> pre statements!
[ -z "$PATHWAY" ] && PATHWAY="`pwd`" || PATHWAY+='/scripts'

while getopts 'srvh' OPTION; do
	case "$OPTION" in
		l) FLAG_SYMLINK=true;;
		s) FLAG_SUDO=true;;
		r) FLAG_ROOT=true;;
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

if [[ -z "$SUDO" && "$uid" -ne 0 ]]; then
	echo "$script: run with root privileges"
	exit 1
elif ! "${FLAG_SUDO:-false}"; then
	if "${FLAG_ROOT:-false}" || [ "$uid" -eq 0 ]; then
		unset SUDO
	fi
fi

# ***** PROGRAM START *****
if "$FLAG_SYMLINK"; then
	copy2symlink
else
	execute-all
fi
