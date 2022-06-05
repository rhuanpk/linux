#!/usr/bin/env bash

# Loop de comandos

verify_privileges() {
        if [ ${UID} -eq 0 ]; then
                echo -e "ERROR: Run this program without privileges!\nExiting..."
                exit 1
        fi
}

print_usage() {
        cat <<- EOF
		####################################################################################
		#
		# >>> $(basename ${0^^}) !
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
		# $(basename ${0}) "sudo fdisk -l /dev/sda1" 5
		#
		# ----------------------------------------------------------------------------------
		#
		# OBS: Por default o pragrama tem um delay de 1s e roda o comando "ls -lhF --color"
		#
		####################################################################################
	EOF
}

# verify_privileges

[ ${#} -lt 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>>>> PROGRAM START <<<<<

time=1

[ ${#} -eq 0 ] && command='ls -lhF --color' || {
	[ ${#} -eq 1 ] && command="${1}" || {
		command="${1}"
		time=${2}
	}
}

while :; do sleep ${time}; clear; eval ${command}; done
