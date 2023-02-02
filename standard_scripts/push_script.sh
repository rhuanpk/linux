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

main_path="/tmp"
repositories=$(ls ${main_path})
flag_custom_mode=false
flag_git_pull_all=false

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

print_path() {
	echo -e "\n\
		\r###################################################################\n\
		\r#\n\
		\r# Atual path: ${main_path}\n\
		\r#\n\
		\r###################################################################\n\
	\r"
}

switch_path(){
	echo -e "\nAtual path: \e[33m${main_path}\e[m\n"
	read -p "Enter with the new path: " new_path
	if [ -z "${new_path}" ]; then
		echo -e "\n\e[31m> The path can not is null !\e[m\n"; exit 1
	elif [ ! -d "${new_path}" ]; then
		echo -e "\n\e[31m> The path not exist !\e[m\n"; exit 1
	else
		sudo sed -i "14s~.*~main_path=\"${new_path}\"~" "${0}"
		echo -e "\n\e[32m> New path successfully changed !\e[m\n"; exit 0
	fi
}

pushing() {
	git_message="${1:-'refresh'}"
	git_branch="${2:-$(git branch --show-current)}"
	git add ./
	git commit -m "${git_message}"
	git push origin "${git_branch}"
}

while getopts 'hvscg' opts 2>/dev/null; do
	case ${opts} in
		h) print_usage; exit 0;;
		v) print_path; exit 0;;
		s) switch_path;;
		c) flag_custom_mode=true;;
		g) flag_git_pull_all=true;;
		*) echo -e "\n\e[31;1m>> Invalid argument !!\e[m\n$(print_usage)\n"; exit 1;;
	esac
done

shift $((${OPTIND}-1))

verify_privileges() {
	[ $UID -eq 0 ] && {
		echo -e "ERROR: Run this program without privileges!\nExiting..."
		exit 1
	}
}

############ BEGIN OF PROGRAM ############

verify_privileges

for directory in ${repositories}; do
	cd ${main_path}/${directory}
	echo -e "\n → git in *${directory^^}* !\n"
	if ${flag_custom_mode}; then
		read -rp 'Edit this repository? (y)es/(n)ext: ' answer
	        [ ${answer,,} = 'n' ] 2>&- && continue
		read -rp "Enter with the message: " git_message
		read -rp "Enter with the branch: " git_branch
		echo ""
		pushing $git_message $git_branch
	elif ${flag_git_pull_all}; then
		git pull origin "$(git branch --show-current)"
	else
		[ $# -eq 0 ] && pushing || $*
	fi
done

echo ""
