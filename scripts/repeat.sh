#!/usr/bin/env bash

# Loop for commands.

# >>> variable declarations!
script=`basename $(readlink -f "$0")`

#home=${HOME:-/home/${USER:-`id -nu`}}
#home=${HOME:-/home/${USER:-`whoami`}}

# >>> function declarations!
verify-privileges() {
	[ $UID -eq 0 ] && {
		echo -e "ERROR: Run this program without privileges!\nExiting..."
		exit 1
	}
}

print-usage() {
        cat <<- EOF
		#######################################################################################
		#
		# >>> $script !
		#
		#
		# Script que deixar algum comando em loop com controle de tempo de atualização
		#
		# Parâmetros passados:
		#
		# 	1: Tempo (em segundos) para atualização do comando; # Proteção de aspas opcional.
		#
		# 	2: Comando a ser repetido; # Proteção de aspas opcional.
		#
		# Exemplos:
		#
		# $script 3 lsblk
		#
		# $script 1 'sudo fdisk -l /dev/sda'
		#
		# $script 5 "ls -lhF ~/*"
		#
		# Dicas:
		#
		# 	1. Caso deseje repitira algum alias ou função customizade passe com BASH_ENV.
		#
		#######################################################################################
	EOF
}


# >>> pre statements !

set +o histexpand

#verify-privileges
[ "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print-usage
        exit 1
}

# >>> *** PROGRAM START *** !
unset TIME COMMAND

TIME=${@:1:1}
COMMAND=${*:2}

if alias "$COMMAND" &>/dev/null; then
	COMMAND=$(sed -En "s/^alias $COMMAND='(.*)'/\1/p" <<< "`alias $COMMAND`")
fi

while :; do
	sleep ${TIME:?'needs informe a time delay as first param!'}
	clear
	eval "${COMMAND:?'needs informe a command to run as second param!'}"
done
