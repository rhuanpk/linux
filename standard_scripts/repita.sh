#!/usr/bin/env bash

###############################################################################
#
# >>> REPITA !
#
# 
# Script que deixar algum comando em loop com controle de tempo de atualização
#
# Parâmetros passados:
#
#    1: Comando a ser repetido; # Todo o comando tem que ser protegido por
#       aspas simples ou duplas caso seja um comando composto
#    
#    2: Tempo (em segundos) para atualização do comando; # Proteção de aspas
#       é opcional
#
# Exemplos:
#
# repita lsblk 3
#
# repita "sudo fdisk -l /dev/sda1" 5
#
# ----------------------------------------------------------------------------
#
# OBS: Por default o pragrama tem um delay de 1s e roda o comando "ls -lhF"
#
###############################################################################

# Declaração do comando

repita() {
	while :; do
		if [ "${2}" = "" ]; then
			sleep 1
		else
			sleep ${2}
		fi
		clear
		if [ "${1}" = "" ]; then
			ls -lhF
		else
			${1}
		fi		
	done
}

# INICIO (chamada do programa/função)

repita "${1}" "${2}"

