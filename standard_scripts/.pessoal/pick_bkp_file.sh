#!/usr/bin/env zsh

WAY_BKP="/home/${USER}/Documents/config_files_backup"
WAY_OPT="/opt"
WAY_FONTES="/home/${USER}/Documents/fonts"
WAY_ICONES="/home/${USER}/.icons"
WAY_TEMAS="/home/${USER}/.themes"
WAY_VSCODE="/home/${USER}/.config/Code/User"

ls -1 ${WAY_OPT} | cat -n | tr -s ' ' > ${WAY_BKP}/opts/programas_opt.txt
ls -1 ${WAY_FONTES} | cat -n | tr -s ' ' > ${WAY_BKP}/fontes/lista_fontes.txt
ls -1 ${WAY_ICONES} | cat -n | tr -s ' ' > ${WAY_BKP}/icones/lista_icones.txt
ls -1 ${WAY_TEMAS} | cat -n | tr -s ' ' > ${WAY_BKP}/temas/lista_temas.txt
cp -ru ${WAY_VSCODE}/* ${WAY_BKP}/vscode
