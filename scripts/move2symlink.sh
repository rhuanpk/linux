#!/usr/bin/env bash

# OBS: Whenever you add a new function, add it to the "ALL_FUNCTIONS" array.

# ********** Declaração de Variáveis **********
SCRIPT=`basename "$0"`
SETLOAD_URL='https://raw.githubusercontent.com/rhuanpk/linux/main/scripts/.private/setload.sh'

PATHWAY=${PK_LOAD_LINUX:-`wget -qO - "$SETLOAD_URL" | bash - 2>&- | grep linux`}
[ -z "$PATHWAY" ] && PATHWAY=`pwd`
PATHWAY+=/scripts

ALL_FILES=`ls -1 "$PATHWAY"/*.sh`
ALL_FUNCTIONS=('copy2symlink' 'copy2binary')
EXPRESSION='(backup|git-all|volume-encryption-utility)\.sh'
SUDO='sudo'

# ********** Declaração de Funções **********
print-usage() {
cat << eof
***** $SCRIPT *****

Usage:
	./$SCRIPT [--ony-symlink]

Description:
	Move binaries to the "local/bin" folder converting symlinks but some not.

Options:
	--only-symlink: Move only those that will be converted to symlinks.
eof
}

make-shorthand() {
	name=`basename "${1%.sh}"`
	[[ "$name" =~ '-' ]] && tr '-' '\n' <<< "$name" | cut -c 1 | tr -d '\n' || echo "$name"
}

copy2symlink() {
	for file in `grep -vE "$EXPRESSION" <<< "$ALL_FILES"`; do
		$SUDO ln -sfv "$file" /usr/local/bin/pk/"`make-shorthand "$file"`"
	done
}

copy2binary() {
	for file in `grep -E "$EXPRESSION" <<< "$ALL_FILES"`; do
		$SUDO cp -v "$file" /usr/local/bin/pk/"`make-shorthand "$file"`"
	done
}

execute-all() {
	for func in ${ALL_FUNCTIONS[@]}; do
		$func
	done
}

# ********** Início do Programa **********
[ '-w' = "$1" ] && { unset SUDO; shift; }
case "$1" in
	"") execute-all;;
	--only-symlink) copy2symlink;;
	-h | --help) print-usage;;
	*) print-usage;;
esac
