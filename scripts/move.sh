#!/usr/bin/bash

# Move all or some specifies scripts to the PATH directories.

# >>> variables declaration!
readonly version='1.2.0'
readonly script="`basename "$0"`"
readonly uid="${UID:-`id -u`}"

SUDO='sudo'
GIT_URL='https://raw.githubusercontent.com/rhuanpk/linux/main/scripts/.private/setload.sh'
SCRIPTS_PATH="${PK_LOAD_LINUX:-`wget -qO - "$GIT_URL" | bash - 2>&- | grep -F linux`}"
LOCAL_BIN=~/.local/bin

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Copy all or some specifies scripts to ~/.local/bin/ folder.
Also remove the file extension on coping e.g.: 'script.sh' -> 'script'

NOTE: Execute this script first time inside your self folder with "./".

Usage:
	- To move all run: $script
	- To move some scripts run: $script 'script1.sh' 'script2.sh'

Options:
	-u: Saves in \`/usr/local/bin/\`;
	-l: List the scripts;
	-v: Print version;
	-h: Print this help.
EOF
}

privileges() {
	local FLAG_SUDO="$1"
	local FLAG_ROOT="$2"
	[ "$3" -a "$3" = 'true' ] && SUDO='sudo'
	if [[ -z "$SUDO" && "$uid" -ne 0 ]]; then
		echo "$script: run with root privileges"
		exit 1
	elif ! "$FLAG_SUDO"; then
		if "$FLAG_ROOT" || [ "$uid" -eq 0 ]; then
			unset SUDO
		fi
	fi 2>&-
}

list-scripts() {
	cd "$SCRIPTS_PATH/"
	echo "$script: in '`pwd`':"
	ls -1 --color='auto' *.sh
}

# >>> pre statements!
privileges false true
[ -z "$SCRIPTS_PATH" ] && SCRIPTS_PATH="`pwd`" || SCRIPTS_PATH+='/scripts'

while getopts 'ulvh' option; do
	case "$option" in
		u)
			LOCAL_BIN='/usr/local/bin'
			privileges false false true
		;;
		l) list-scripts; exit;;
		v) echo "$version"; exit 0;;
		h) usage; exit 1;;
		*) exit 2;;
	esac
done
shift $(("$OPTIND"-1))

$SUDO mkdir -pv "$LOCAL_BIN/"
. ~/.${SHELL##*/}rc
[[ ! "$PATH" =~ "$LOCAL_BIN" ]] && {
	cat <<- EOF >> ~/.bashrc

		# By \`$script' script
		PATH='$LOCAL_BIN:\$PATH'
	EOF
}

# ***** PROGRAM START *****
[ "$#" -eq 0 ] && {
	for file in "$SCRIPTS_PATH"/*.sh; do
		$SUDO cp -fv "$file" "$LOCAL_BIN/`basename ${file%.*}`"
	done
} || {
	for file; do
		$SUDO cp -fv "$SCRIPTS_PATH/$file" "$LOCAL_BIN/${file%.*}"
	done
}
