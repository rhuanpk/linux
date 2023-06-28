#!/usr/bin/env bash

# Make a backup of some important files.

# >>> variable declarations !

script=$(basename "${0}")
home=${HOME:-/home/${USER:-$(whoami)}}

# >>> function declarations !

verify_privileges() {
	[ $UID -eq 0 ] && {
		echo -e "ERROR: Run this program without privileges!\nExiting..."
		exit 1
	}
}

print_usage() {
        echo -e "Run:\n\t./${script}"
}

# >>> pre statements !

set +o histexpand

verify_privileges
[ $# -ge 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>> *** PROGRAM START *** !

cleanup-history() {
	for file in "${array_pathway_backup[history]}"/*; do
		find "$file" -mtime +2 -exec rm '{}' \;
	done
}

path_backup=${home}/Documents/config_files_backup/`hostname`
declare -A array_pathway_backup=(\
	[opt]=${path_backup}/opt \
	[fonts]=${path_backup}/fonts \
	[iconthemes]=${path_backup}/icons_themes \
	[terminator]=${path_backup}/terminator \
	[dpkg]=${path_backup}/dpkg \
	[neofetch]=${path_backup}/neofetch \
	[others]=${path_backup}/others \
	[gtk]=${path_backup}/gtk \
	[localbin]=${path_backup}/local_bin \
	[history]=${path_backup}/history\
)

for pathway in ${array_pathway_backup[@]}; do
	[ ! -d "${pathway}" ] && mkdir -p "${pathway}"
done

path_opt=/opt
path_fonts=${home}/Documents/fonts
path_icons=${home}/.icons
path_themes=${home}/.themes
path_terminator=${home}/.config/terminator/config
path_tree=${home}/others
path_gtk=${home}/.config/gtk-3.0/settings.ini
path_localbin=/usr/local/bin
path_history=${home}/.bash_history

# ls commands to save.
ls -1 ${path_opt} | cat -n | tr -s ' ' >${array_pathway_backup[opt]}/opt_programs.txt
ls -1 ${path_fonts} | cat -n | tr -s ' ' >${array_pathway_backup[fonts]}/fonts.txt
ls -1 ${path_icons} | cat -n | tr -s ' ' >${array_pathway_backup[iconthemes]}/icons.txt
ls -1 ${path_themes} | cat -n | tr -s ' ' >${array_pathway_backup[iconthemes]}/themes.txt
ls -1 ${path_localbin} | cat -n | tr -s ' ' >${array_pathway_backup[localbin]}/binaries.txt

# cp commands to save.
cp -f ${path_terminator} ${array_pathway_backup[terminator]}/config.txt
cp -f ${path_gtk} ${array_pathway_backup[gtk]}/settings.txt

# others commands to save.
tree ${path_tree} >${array_pathway_backup[others]}/tree_output.txt
dpkg -l >${array_pathway_backup[dpkg]}/list.txt
neofetch >${array_pathway_backup[neofetch]}/infos.txt
gzip -cv9 "$path_history" > "${array_pathway_backup[history]}"/`date +%y-%m-%d_%H%M%S_bash-history.gz`

# clean ups.
cleanup-history
