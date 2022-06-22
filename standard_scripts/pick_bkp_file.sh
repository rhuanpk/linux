#!/usr/bin/env bash

# ------------------------------------------------------
# OBS: ainda é necessário deixar esse script automático
# ------------------------------------------------------

# Make a backup of some important files

# crontab:
# */30 * * * * /usr/local/bin/pk-pick_bkp_file 2>/tmp/cron_error.log

verify_privileges() {
        if [ ${UID} -eq 0 ]; then
                echo -e "ERROR: Run this program without privileges!\nExiting..."
                exit 1
        fi
}

print_usage() {
        echo -e "Run:\n\t./$(basename ${0})"
}

verify_privileges

[ ${#} -ge 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>>>> PROGRAM START <<<<<

user=user
home=/home/${user}
path_bkp=${home}/Documents/config_files_backup

path_opt=/opt
PATH_FONTES=${home}/Documents/fonts
PATH_ICONES=${home}/.icons
PATH_TEMAS=${home}/.themes
PATH_TERMINATOR=${home}/.config/terminator/config
PATH_EXECUTABLES=${home}/others/executables
PATH_TREE=${home}/others

ARR_PATH=(\
	${path_bkp}/opt \
	${path_bkp}/fonts \
	${path_bkp}/icons_themes \
	${path_bkp}/terminator \
	${path_bkp}/dpkg \
	${path_bkp}/neofetch \
	${path_bkp}/executables \
	${path_bkp}/others\
)

for path in ${ARR_PATH[@]}; do
	[ ! -d ${path} ] && mkdir -p ${path}
done

ls -1 ${path_opt} | cat -n | tr -s ' ' > ${path_bkp}/opt/programas_opt.txt
ls -1 ${PATH_FONTES} | cat -n | tr -s ' ' > ${path_bkp}/fonts/fonts.txt
ls -1 ${PATH_ICONES} | cat -n | tr -s ' ' > ${path_bkp}/icons_themes/icons.txt
ls -1 ${PATH_TEMAS} | cat -n | tr -s ' ' > ${path_bkp}/icons_themes/themes.txt
ls -1 ${PATH_EXECUTABLES} | cat -n | tr -s ' ' > ${path_bkp}/executables/exebutables.txt
cp ${PATH_TERMINATOR} ${path_bkp}/terminator/config.txt
dpkg -l | tee ${path_bkp}/dpkg/list.txt
neofetch > ${path_bkp}/neofetch/infos.txt
tree ${PATH_TREE} > ${path_bkp}/others/tree_output.txt
