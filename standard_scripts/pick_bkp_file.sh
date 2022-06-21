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
PATH_BKP=${home}/Documents/config_files_backup

PATH_OPT=/opt
PATH_FONTES=${home}/Documents/fonts
PATH_ICONES=${home}/.icons
PATH_TEMAS=${home}/.themes
PATH_TERMINATOR=${home}/.config/terminator/config
PATH_EXECUTABLES=${home}/others/executables
PATH_TREE=${home}/others

ARR_PATH=(\
	${PATH_BKP}/opt \
	${PATH_BKP}/fonts \
	${PATH_BKP}/icons_themes \
	${PATH_BKP}/terminator \
	${PATH_BKP}/dpkg \
	${PATH_BKP}/neofetch \
	${PATH_BKP}/executables \
	${PATH_BKP}/others\
)

for path in ${ARR_PATH[@]}; do
	[ ! -d ${path} ] && mkdir -p ${path}
done

ls -1 ${PATH_OPT} | cat -n | tr -s ' ' > ${PATH_BKP}/opt/programas_opt.txt
ls -1 ${PATH_FONTES} | cat -n | tr -s ' ' > ${PATH_BKP}/fonts/fonts.txt
ls -1 ${PATH_ICONES} | cat -n | tr -s ' ' > ${PATH_BKP}/icons_themes/icons.txt
ls -1 ${PATH_TEMAS} | cat -n | tr -s ' ' > ${PATH_BKP}/icons_themes/themes.txt
ls -1 ${PATH_EXECUTABLES} | cat -n | tr -s ' ' > ${PATH_BKP}/executables/exebutables.txt
cp ${PATH_TERMINATOR} ${PATH_BKP}/terminator/config.txt
dpkg -l | tee ${PATH_BKP}/dpkg/list.txt
neofetch > ${PATH_BKP}/neofetch/infos.txt
tree ${PATH_TREE} > ${PATH_BKP}/others/tree_output.txt
