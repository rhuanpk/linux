#!/usr/bin/bash

# Move all or some specifies scripts to the PATH directories.

# >>> variables declaration!
readonly version='1.1.0'
readonly script="`basename "$0"`"
readonly uid="${UID:-`id -u`}"

SUDO='sudo'
GIT_URL='https://raw.githubusercontent.com/rhuanpk/linux/main/scripts/.private/setload.sh'
SCRIPTS_PATH="${PK_LOAD_LINUX:-`wget -qO - "$GIT_URL" | bash - 2>&- | grep -F linux`}"
LOCAL_BIN='/usr/local/bin'

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Move all or some specifies scripts to the \`/usr/local/bin\` folder.
NOTE: Execute this script first time inside your self folder with \`./\`.

Usage:
	- To move all: $script
	- To move some scripts: $script 'script-1.sh' 'script-2.sh'

Options:
	-h: Saves the scripts in '~/.local/bin/';
	-s: Forces keep sudo;
	-r: Forces unset sudo;
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

# >>> pre statements!
[ -z "$SCRIPTS_PATH" ] && SCRIPTS_PATH="`pwd`" || SCRIPTS_PATH+='/scripts'

while getopts 'hsrvh' option; do
	case "$option" in
		h) LOCAL_BIN=~/.local/bin/;;
		s) privileges true false;;
		r) privileges false true;;
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

privileges false false
$SUDO mkdir -pv "$LOCAL_BIN"

# ***** PROGRAM START *****
[ "$#" -eq 0 ] && {
	for file in "$SCRIPTS_PATH"/*.sh; do
		$SUDO cp -v "$file" "$LOCAL_BIN/`basename ${file%.*}`"
	done
} || {
	for file; do
		if ! $SUDO cp -v "$SCRIPTS_PATH/$file" "$LOCAL_BIN/${file%.*}"; then
			print_usage
			exit 1
		fi
	done
}
