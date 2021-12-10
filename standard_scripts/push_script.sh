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

path="/tmp/tmp/git"
repo=$(ls -1 ${path} | sed 's/$/ /g' | tr -d '\n')

print_usage(){
	echo -e "\n\
	       	\r###################################################################\n\
		\r#\n\
		\r# \e[1mOPTIONS\e[m\n\
		\r#\n\
		\r#\t\e[1m-h\e[m: Print this message and exit with 0\n\
		\r#\t\e[1m-v\e[m: View the atual path selected and exit with 0\n\
		\r#\t\e[1m-s\e[m: Set a new path to grab the folders\n#\t\texample: $ push_script -v \"/path/to/your/repos\"\n\
		\r#\n\
		\r###################################################################\n"
}

switch_path(){
	aux="${path}"
	read -p "Enter with the new path: " path
	if [[ "${path}" == "" ]]; then
		path="${aux}"; exit 0  
	elif [[ ! -e "${path}" ]]; then
		
	else
		# verificar se é o parâmetro -e mesmo ou -f, caso existir (else), então printa status 200
	fi
}

while getopts 'hvs' opts; do
	case ${opts} in
		h)
			print_usage; exit 0 ;;
		v)
			echo -e "\n\
				\r#############################\n\
				\r#\n\
				\r# Atual path: ${path}\n\
				\r#\n\
				\r#############################"; exit 0 ;;
		s)
			switch_path ;;
		*)
			echo -e "\e[41;1m>> Invalid argument !!\e[m $(print_usage)"; exit 1 ;;
	esac
done

shift $((${OPTIND}-1))

for dir in ${repo}; do
	cd ${path}/${dir}
	echo -e "\n → ggpull in *${dir^^}* !\n"
	[[ "${*}" == "" ]] && push.sh || ${*}
done

echo ""
