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

path="/tmp/tmp/importar_descricao"
repo=$(ls -1 ${path} | sed 's/$/ /g' | tr -d '\n')

print_usage(){
	echo -e "\n\
	       	\r###################################################################\n\
		\r#\n\
		\r# \e[1mOPTIONS\e[m\n\
		\r#\n\
		\r#\t\e[1m-h\e[m: Print this message and exit with 0\n\
		\r#\t\e[1m-v\e[m: View the atual path selected and exit with 0\n\
		\r#\t\e[1m-s\e[m: Set a new path to grab the folders\n\
		\r#\n\
		\r###################################################################\n"
}

switch_path(){
	aux="${path}"
	echo "Atual path: ${aux}"
	read -p "Enter with the new path: " path
	if [ "${path}" = "" ]; then
		path="${aux}"
		echo -e "\e[31mThe path can not is null!!!\e[m"; exit 1
	elif [ ! -e "${path}" ]; then
		path="${aux}"
		echo -e "\e[31mThe path not exist!!!\e[m"; exit 1
	else
		sed -i "14s/^.*/path=\"${path}\"/" "${0}"
		echo -e "\e[32m> New path successfully changed !\e[m"; exit 0
	fi
}

while getopts 'hvs' opts 2>/dev/null; do
	case ${opts} in
		h)
			print_usage; exit 0 ;;
		v)
			echo -e "\n\
				\r###################################################################\n\
				\r#\n\
				\r# Atual path: ${path}\n\
				\r#\n\
				\r###################################################################\n"; exit 0 ;;
		s)
			switch_path ;;
		*)
			echo -e "\n\e[31;1m>> Invalid argument !!\e[m\n$(print_usage)\n"; exit 1 ;;
	esac
done

shift $((${OPTIND}-1))

for dir in ${repo}; do
	cd ${path}/${dir}
	echo -e "\n → ggpull in *${dir^^}* !\n"
	[[ "${*}" == "" ]] && push.sh || ${*}
done

echo ""
