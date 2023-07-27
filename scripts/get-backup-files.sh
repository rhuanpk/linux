#!/usr/bin/env bash

# Make a backup of some important files.

# >>> variable declarations !
script=`basename "$0"`
home=${HOME:-/home/${USER:-`whoami`}}

# >>> function declarations !
verify_privileges() {
	[ $UID -eq 0 ] && {
		echo -e "ERROR: Run this program without privileges!\nExiting..."
		exit 1
	}
}

print_usage() {
        echo -e "Run:\n\t./$script"
}

# >>> pre statements !
set +o histexpand

verify_privileges
[ "$#" -ge 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>> *** PROGRAM START *** !
cleanup-history() {
	files=("${ARRAY_PATHWAY_BACKUP['history']}"/*)
	for file in ${files[@]: 0:$((${#files[@]}-1))}; do
		find "$file" -mtime +2 -exec rm -f '{}' \;
	done
}

PATHWAY_BACKUP=$home/Documents/config-files-backup/`hostname`
declare -A ARRAY_PATHWAY_BACKUP=( \
	['opt']="$PATHWAY_BACKUP/opt" \
	['fonts']="$PATHWAY_BACKUP/fonts" \
	['iconthemes']="$PATHWAY_BACKUP/icons-themes" \
	['terminator']="$PATHWAY_BACKUP/terminator" \
	['dpkg']="$PATHWAY_BACKUP/dpkg" \
	['neofetch']="$PATHWAY_BACKUP/neofetch" \
	['misc']="$PATHWAY_BACKUP/misc" \
	['gtk']="$PATHWAY_BACKUP/gtk" \
	['localbin']="$PATHWAY_BACKUP/local-bin" \
	['history']="$PATHWAY_BACKUP/history" \
)

for pathway in ${ARRAY_PATHWAY_BACKUP[@]}; do
	[ ! -d "$pathway/" ] && mkdir -p "$pathway/"
done

PATHWAY_OPT='/opt'
PATHWAY_FONTS="$home/Documents/fonts"
PATHWAY_ICONS="$home/.icons"
PATHWAY_THEMES="$home/.themes"
PATHWAY_TERMINATOR="$home/.config/terminator/config"
PATHWAY_TREE="$home/misc"
PATHWAY_GTK="$home/.config/gtk-3.0/settings.ini"
PATHWAY_LOCALBIN="/usr/local/bin"
PATHWAY_HISTORY="$home/.bash_history"

# Clean ups.
cleanup-history

# Commands ls to save.
ls -1 "$PATHWAY_OPT" | cat -n | tr -s ' ' >"${ARRAY_PATHWAY_BACKUP['opt']}/opt-programs.txt"
ls -1 "$PATHWAY_FONTS" | cat -n | tr -s ' ' >"${ARRAY_PATHWAY_BACKUP['fonts']}/fonts.txt"
ls -1 "$PATHWAY_ICONS" | cat -n | tr -s ' ' >"${ARRAY_PATHWAY_BACKUP['iconthemes']}/icons.txt"
ls -1 "$PATHWAY_THEMES" | cat -n | tr -s ' ' >"${ARRAY_PATHWAY_BACKUP['iconthemes']}/themes.txt"
ls -1 "$PATHWAY_LOCALBIN" | cat -n | tr -s ' ' >"${ARRAY_PATHWAY_BACKUP['localbin']}/binaries.txt"

# Commands cp to save.
cp -f "$PATHWAY_TERMINATOR" "${ARRAY_PATHWAY_BACKUP['terminator']}/config.txt"
cp -f "$PATHWAY_GTK" "${ARRAY_PATHWAY_BACKUP['gtk']}/settings.txt"

# Others commands to save.
tree "$PATHWAY_TREE" >"${ARRAY_PATHWAY_BACKUP['misc']}/tree-output.txt"
dpkg -l >"${ARRAY_PATHWAY_BACKUP['dpkg']}/list.txt"
neofetch >"${ARRAY_PATHWAY_BACKUP['neofetch']}/infos.txt"

# Complex commands to save.
FILE_NAME_HISTORY="${ARRAY_PATHWAY_BACKUP['history']}/`date +%y-%m-%d_%H%M%S_bash-history.gz`"
gzip -c9 "$PATHWAY_HISTORY" > "$FILE_NAME_HISTORY"
chmod 600 "$FILE_NAME_HISTORY"
