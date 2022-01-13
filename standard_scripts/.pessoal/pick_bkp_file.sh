#!/usr/bin/env zsh

WAY_BKP="/home/${USER}/Documents/config_files_backup"
WAY_OPT="/opt"
WAY_FONTES="/home/${USER}/Documents/fonts"
WAY_ICONES="/home/${USER}/.icons"
WAY_TEMAS="/home/${USER}/.themes"
WAY_VSCODECFG="/home/${USER}/.config/Code/User"
WAY_VSCODEEXT="/home/${USER}/.vscode/extensions"
WAY_NOTI="/home/${USER}/.config/noti"

ls -1 ${WAY_OPT} | cat -n | tr -s ' ' > ${WAY_BKP}/opts/programas_opt.txt
ls -1 ${WAY_FONTES} | cat -n | tr -s ' ' > ${WAY_BKP}/fontes/lista_fontes.txt
ls -1 ${WAY_ICONES} | cat -n | tr -s ' ' > ${WAY_BKP}/icones/lista_icones.txt
ls -1 ${WAY_TEMAS} | cat -n | tr -s ' ' > ${WAY_BKP}/temas/lista_temas.txt
cp -r ${WAY_VSCODECFG}/* ${WAY_BKP}/vscode/configuracoes
cp -ru ${WAY_VSCODEEXT}/* ${WAY_BKP}/vscode/extensoes
cp -r ${WAY_NOTI}/* ${WAY_BKP}/noti
