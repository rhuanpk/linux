#!/usr/bin/env bash

WAY_BKP="/home/${USER}/Documents/config_files_backup"
WAY_OPT="/opt"
WAY_FONTES="/home/${USER}/Documents/fonts"
WAY_ICONES="/home/${USER}/.icons"
WAY_TEMAS="/home/${USER}/.themes"
WAY_TERMINATOR="/home/${USER}/.config/terminator/config"

ARR_WAY=("${WAY_BKP}/opt" "${WAY_BKP}/fontes" "${WAY_BKP}/icones_temas" "${WAY_BKP}/terminator" "${WAY_BKP}/dpkg" "${WAY_BKP}/neofetch")

for index in ${ARR_WAY[@]}; do
	[ ! -d "${index}" ] && mkdir -p "${index}"
done

ls -1 ${WAY_OPT} | cat -n | tr -s ' ' > ${WAY_BKP}/opt/programas_opt.txt
ls -1 ${WAY_FONTES} | cat -n | tr -s ' ' > ${WAY_BKP}/fontes/fontes.txt
ls -1 ${WAY_ICONES} | cat -n | tr -s ' ' > ${WAY_BKP}/icones_temas/icones.txt
ls -1 ${WAY_TEMAS} | cat -n | tr -s ' ' > ${WAY_BKP}/icones_temas/temas.txt
cp ${WAY_TERMINATOR} > ${WAY_BKP}/terminator/config.txt
dpkg -l | tee ${WAY_BKP}/dpkg/list.txt
neofetch > ${WAY_BKP}/neofetch/infos.txt
