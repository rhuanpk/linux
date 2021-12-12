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

path="/tmp/tmp/dir_1"
repo=$(ls -1 ${path} | sed 's/$/ /g' | tr -d '\n')
flag_custom_mode=0

print_usage(){
	echo -e "\n\
	       	\r###################################################################\n\
		\r#\n\
		\r# \e[1mSYNOPSIS\e[m\n\
		\r#\n\
		\r#\t \e[1mNormal Mode:\e[m\n\
		\r#\n\
		\r#\t Pass the git command to be used as a parameter,\n\
		\r#\t if no parameters are passed it will push by default.\n\
		\r#\t The parameter can be passed without double quotes.\n\
		\r#\n\
		\r#\t In this usage mode, neither the confirmation\n\
		\r#\t message nor the branch can be defined.\n\
		\r#\t By default it confirms with the message \"refresh!\" in the master branch\n\
		\r#\n\
		\r#\t \e[1mCustom Mode:\e[m\n\
		\r#\n\
		\r#\t At each iteration of the loop you can set\n\
		\r#\t the message and branch of the current repository.\n\
		\r#\t This mode only accepts git push\n\
		\r#\n\
		\r# \e[1mHOW TO USE\e[m\n\
		\r#\n\
		\r#\t Example passing parameters:\n\
		\r#\t\t $ push_script.sh \e[33mgit status\e[m\n\
		\r#\t\t OR\n\
		\r#\t\t $ push_script.sh \e[33m\"git pull origin master\"\e[m\n\
		\r#\n\
		\r#\t Example without passing parameters:\n\
		\r#\t\t $ push_script.sh\n\
		\r#\n\
		\r# \e[1mOPTIONS\e[m\n\
		\r#\n\
		\r#\t\e[1m-h\e[m: Print this message and exit with 0\n\
		\r#\t\e[1m-v\e[m: View the atual path selected and exit with 0\n\
		\r#\t\e[1m-s\e[m: Set a new path to grab the folders\n\
		\r#\t\e[1m-c\e[m: Start the CUSTOM MODE\n\
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
		sed -i "14s~^.*~path=\"${path}\"~" ${0}
		echo -e "\e[32m> New path successfully changed !\e[m"; exit 0
	fi
}

while getopts 'hvsc' opts 2>/dev/null; do
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
		c)
			flag_custom_mode=1 ;;
		*)
			echo -e "\n\e[31;1m>> Invalid argument !!\e[m\n$(print_usage)\n"; exit 1 ;;
	esac
done

shift $((${OPTIND}-1))

############ BEGIN OF PROGRAM ############

for dir in ${repo}; do
	cd ${path}/${dir}
	echo -e "\n → ggpull in *${dir^^}* !\n"
	if [ ${flag_custom_mode} -eq 1 ]; then
		read -p "Enter with the message: " msg_git
		read -p "Enter with the branch: " branch_git	
		echo ""
		push.sh "${msg_git}" "${branch_git}"
	else
		[[ "${*}" == "" ]] && push.sh || ${*}
	fi
done

echo ""
