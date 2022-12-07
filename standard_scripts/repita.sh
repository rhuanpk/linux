#!/usr/bin/env bash

# Loop for commands.

script=$(basename ${0})

verify_privileges() {
        if [ ${UID} -eq 0 ]; then
                echo -e "ERROR: Run this program without privileges!\nExiting..."
                exit 1
        fi
}

print_usage() {
        cat <<- EOF
		#######################################################################################
		#
		# >>> ${script^^} !
		#
		# 
		# Script que deixar algum comando em loop com controle de tempo de atualização
		#
		# Parâmetros passados:
		#
		#    1: Tempo (em segundos) para atualização do comando; # Proteção de aspas opcional.
		#
		#    2: Comando a ser repetido; # Proteção de aspas opcional.
		#
		# Exemplos:
		#
		# $script 3 lsblk
		#
		# $script 1 'sudo fdisk -l /dev/sda'
		#
		# $script 5 "ls -lhF ~/*"
		#
		#######################################################################################
	EOF
}

# verify_privileges

[ "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>>>> PROGRAM START <<<<<

unset time command

time=${@:1:1}
command="${*:2}"

while :; do
	sleep ${time:?'needs informe a time delay as first param!'}
	clear
	eval "${command:?'needs informe a command to run as second param!'}"
done
