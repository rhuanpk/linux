#!/usr/bin/env bash

# crontab:
# */30 * * * * /usr/local/bin/pk-pick_bkp_file 2>/tmp/cron_error.log

USER='user'
WAY_BKP="/home/${USER}/Documents/config_files_backup"
WAY_OPT="/opt"
WAY_FONTES="/home/${USER}/Documents/fonts"
WAY_ICONES="/home/${USER}/.icons"
WAY_TEMAS="/home/${USER}/.themes"
WAY_TERMINATOR="/home/${USER}/.config/terminator/config"
WAY_EXECUTABLES="/home/${USER}/others/executables"
WAY_TREE="/home/${USER}/others"

ARR_WAY=("${WAY_BKP}/opt" "${WAY_BKP}/fonts" "${WAY_BKP}/icons_themes" "${WAY_BKP}/terminator" "${WAY_BKP}/dpkg" "${WAY_BKP}/neofetch" "${WAY_BKP}/executables" "${WAY_BKP}/others")

for index in ${ARR_WAY[@]}; do
	[ ! -d "${index}" ] && mkdir -p "${index}"
done

ls -1 "${WAY_OPT}" | cat -n | tr -s ' ' > "${WAY_BKP}/opt/programas_opt.txt"
ls -1 "${WAY_FONTES}" | cat -n | tr -s ' ' > "${WAY_BKP}/fonts/fonts.txt"
ls -1 "${WAY_ICONES}" | cat -n | tr -s ' ' > "${WAY_BKP}/icons_themes/icons.txt"
ls -1 "${WAY_TEMAS}" | cat -n | tr -s ' ' > "${WAY_BKP}/icons_themes/themes.txt"
ls -1 "${WAY_EXECUTABLES}" | cat -n | tr -s ' ' > "${WAY_BKP}/executables/exebutables.txt"
cp "${WAY_TERMINATOR}" "${WAY_BKP}/terminator/config.txt"
dpkg -l | tee "${WAY_BKP}/dpkg/list.txt"
neofetch > "${WAY_BKP}/neofetch/infos.txt"
tree "${WAY_TREE}" > "${WAY_BKP}/others/tree_output.txt"
