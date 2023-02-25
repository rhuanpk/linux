#!/usr/bin/env bash

# -------------------------------------------------------
# OBS: ainda é necessário deixar esse script automático.
# -------------------------------------------------------

# Make a backup of some important files.

# crontab:
# */30 * * * * /usr/local/bin/pk/pick_bkp_file 2>/tmp/cron_error.log

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

home=/home/$(whoami)
bkp_path=${home}/Documents/config_files_backup/$(cat /etc/hostname)

path_opt=/opt
path_fontes=${home}/Documents/fonts
path_icones=${home}/.icons
path_temas=${home}/.themes
path_terminator=${home}/.config/terminator/config
path_tree=${home}/others
path_gtk="${home}/.config/gtk-3.0/settings.ini"
path_local_bin=/usr/local/bin

declare -A arr_path=(\
	[opt]=${bkp_path}/opt \
	[fon]=${bkp_path}/fonts \
	[ico_the]=${bkp_path}/icons_themes \
	[ter]=${bkp_path}/terminator \
	[dpk]=${bkp_path}/dpkg \
	[neo]=${bkp_path}/neofetch \
	[oth]=${bkp_path}/others \
	[gtk]=${bkp_path}/gtk \
	[loc_bin]=${bkp_path}/local_bin\
)

for path in ${arr_path[@]}; do
	[ ! -d ${path} ] && mkdir -p ${path}
done

ls -1 ${path_opt} | cat -n | tr -s ' ' >${arr_path[opt]}/programas_opt.txt
ls -1 ${path_fontes} | cat -n | tr -s ' ' >${arr_path[fon]}/fonts.txt
ls -1 ${path_icones} | cat -n | tr -s ' ' >${arr_path[ico_the]}/icons.txt
ls -1 ${path_temas} | cat -n | tr -s ' ' >${arr_path[ico_the]}/themes.txt
ls -1 ${path_local_bin} | cat -n | tr -s ' ' >${arr_path[loc_bin]}/binaries.txt
cp ${path_terminator} ${arr_path[ter]}/config.txt
cp ${path_gtk} ${arr_path[gtk]}/settings.txt
dpkg -l >${arr_path[dpk]}/list.txt
neofetch >${arr_path[neo]}/infos.txt
tree ${path_tree} >${arr_path[oth]}/tree_output.txt