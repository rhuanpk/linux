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

print_usage(){
	echo " \e[1mOPTIONS\e[m\n\
		\t-h: Print this message and exit with 0\n\
		\t-v: View the atual path selected and exit with 0\n\
		\t-v: Set as new path to get the directories\n\t\texample: $ push_script -v \"/path/to/yours/repos\""
}

switch_path(){
	aux="${path}"
	read -p "Enter with the new path: " path
	[[ "${path}" == "" ]] && path="${aux}"
}

while getopts 'hvs' opts; do
	case ${opts} in
		h)
			print_usage ;;
		v)
			echo "Path atual: ${path}"; exit 0 ;;
		s)
			switch_path ;;
		*)
			echo "\e[41;1m>> Invalid argument !!\e[m $(print_usage)"
	esac
done

shift $((${OPTIND}-1))

for dir in ${repo}; do
	cd ${path}/${dir}
	echo -e "\n → ggpull in *${dir^^}* !\n"
	[[ "${*}" == "" ]] && push.sh || ${*}
done

echo ""
