#!/usr/bin/env bash

##################################################################################
#
# Script que dá push em todos os repos automáticamente
# requisitos:
#    1. Ter o credential.helper ativado
#    2. Ter o script de push no sistema
#
# A variável "path" deve receber o caminho do diretório aonde ficam todos os repos
#
##################################################################################

path="${HOME}/Documents/git"
repo=$(ls -1 ${path} | sed 's/$/ /g' | tr -d '\n')

for dir in ${repo}; do
	cd ${path}/${dir}
	echo -e "\n → ggpull in *${dir^^}* !\n"
	push.sh
done

echo ""
