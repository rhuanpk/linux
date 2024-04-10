#!/usr/bin/bash

# OBS: Whenever you add a new function, add it to the "ALL_FUNCTIONS" array.

# >>> variables declaration!
readonly version='1.1.0'
readonly script="`basename "$0"`"
readonly uid="${UID:-`id -u`}"

SUDO='sudo'
SETLOAD_URL='https://raw.githubusercontent.com/rhuanpk/linux/main/scripts/.private/setload.sh'
PATHWAY=${PK_LOAD_LINUX:-`wget -qO - "$SETLOAD_URL" | bash - 2>&- | grep linux`}
ALL_FILES=`ls -1 "$PATHWAY"/scripts/*.sh`
ALL_FUNCTIONS=('copy2symlink' 'copy2binary')
EXPRESSION='(backup|volume-encryption-utility)\.sh'
LOCAL_BIN='/usr/local/bin/pk'
NO_SHORTHANDS=('vagrant-start.sh')

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Move binaries to \`/usr/local/bin\` folder converting symlinks but some not.

Usage: $script [<options>]

Options:
	-l: Move only those that will be converted to symlinks;
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

make-shorthand() {
	NAME="`basename "${1%.sh}"`"
	[[ "$NAME" =~ - ]] && tr '-' '\n' <<< "$NAME" | cut -c 1 | tr -d '\n' || echo "$NAME"
}

make-filename() {
	FILE="`basename "${1:?needs a file to validade}"`"
	[[ "${NO_SHORTHANDS[@]}" =~ $FILE ]] && echo "${FILE%.sh}" || echo "`make-shorthand "$FILE"`"
}

copy2symlink() {
	for file in `grep -vE "$EXPRESSION" <<< "$ALL_FILES"`; do
		$SUDO ln -sfv "$file" "$LOCAL_BIN/`make-filename "$file"`"
	done
}

copy2binary() {
	for file in `grep -E "$EXPRESSION" <<< "$ALL_FILES"`; do
		$SUDO cp -v "$file" "$LOCAL_BIN/`make-filename "$file"`"
	done
}

execute-all() {
	for func in "${ALL_FUNCTIONS[@]}"; do $func; done
}

# >>> pre statements!
[ -z "$PATHWAY" ] && PATHWAY="`pwd`" || PATHWAY+='/scripts'

while getopts 'lhsrvh' OPTION; do
	case "$OPTION" in
		l) FLAG_SYMLINK='true';;
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
if "${FLAG_SYMLINK:-false}"; then
	copy2symlink
else
	execute-all
fi
