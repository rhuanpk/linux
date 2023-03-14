#!/usr/bin/env bash

##################################################################################
#
# Script que dá push em todos os repos automáticamente.
# Requisitos:
#    1. Ter o credential.helper ativado
#
# A variável "_repo_paths" deve receber o caminho do diretório aonde ficam todos os repos.
#
##################################################################################

script=`basename "${0}"`

_repo_paths='/tmp'
flag_custom_mode=false
flag_git_pull_all=false

formatter() {
	formatting="${1}"
	[[ "${formatting}" =~ ([[:digit:]]+;?)* ]] && message="${@:2}" || message="${*}"
	echo -e "\e[${formatting}m${message}\e[m"
}

print_usage(){
	cat <<- eof

		####################################################################################################
		#
		# `formatter 1 SYNOPSIS`
		#
		# `formatter 1 Normal Mode`:
		# 	Pass the git command to be used as a parameter,
		# 	if no parameters are passed it will push by default.
		# 	The parameter can be passed without double quotes.
		#
		# 	In this usage mode, neither the confirmation
		# 	message nor the branch can be defined.
		# 	By default it confirms with the message "refresh!" in the master branch.
		#
		# `formatter 1 Custom Mode`:
		# 	At each iteration of the loop you can set
		# 	the message and branch of the current repository.
		# 	This mode only accepts git push.
		#
		# `formatter 1 HOW TO USE`
		#
		# Example passing parameters:
		# 	${script} `formatter 33 git status`
		# OR
		# 	${script} `formatter 33 '"git pull origin master"'`
		#
		# Example without passing parameters:
		# 	${script}
		#
		# `formatter 1 OPTIONS`
		#
		# 	`formatter 1 -h`: Print this message and exit with 0.
		# 	`formatter 1 -v`: View the atual path selected and exit with 0.
		# 	`formatter 1 -s`: Set a new path to grab the folders.
		# 	`formatter 1 -p`: Set a temporary path (that's valid only this time) to grab the folders.
		# 	`formatter 1 -c`: Start the CUSTOM MODE.
		# 	`formatter 1 -g`: Pull in all repos.
		#
		####################################################################################################

	eof
}

print_exiting() {
	echo -e "\n`formatter '31;1' '>>> Invalid option !'`\n`print_usage`\n"
}

print_path() {
	cat <<- eof

		Atual path: `formatter 33 ${_repo_paths}`

	eof
}

switch_path(){
	echo -e "\nAtual path: `formatter 33 ${_repo_paths}`\n"
	read -p "Enter with the new path: " new_path
	if [ -z "${new_path}" ]; then
		echo -e "\n`formatter 31 '> The path can not is null !'`\n"; exit 1
	elif [ ! -d "${new_path}" ]; then
		echo -e "\n`formatter 31 '> The path not exist !'`\n"; exit 1
	else
		if sudo sed -Ei "s~(^_repo_paths=')(.*)~\1${new_path}'~" "${0}"; then
			echo -e "\n`formatter 32 '> New path successfully changed !'`\n"; exit 0
		else
			echo -e "\n`formatter 31 '> New path NOT successfully changed !'`\n"; exit 0
		fi
	fi
}

pushing() {
	git_message="${1:-'refresh'}"
	git_branch="${2:-`git branch --show-current`}"
	git add ./
	git commit -m "${git_message}"
	git push origin "${git_branch}"
}

while getopts 'hvsp:cg' opts 2>/dev/null; do
	case ${opts} in
		h) print_usage; exit 0;;
		v) print_path; exit 0;;
		s) switch_path;;
		p) _repo_paths="${OPTARG}";;
		c) flag_custom_mode=true;;
		g) flag_git_pull_all=true;;
		?) print_exiting; exit 1;;
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

for directory in `ls ${_repo_paths}`; do
	cd ${_repo_paths}/${directory}
	echo -e "\n → git in *${directory^^}* !\n"
	if ${flag_custom_mode}; then
		read -rp 'Edit this repository? (y)es/(n)ext: ' answer
	        [ ${answer,,} = 'n' ] 2>&- && continue
		read -rp "Enter with the message: " git_message
		read -rp "Enter with the branch: " git_branch
		echo ""
		pushing $git_message $git_branch
	elif ${flag_git_pull_all}; then
		git pull origin "`git branch --show-current`"
	else
		[ $# -eq 0 ] && pushing || $*
	fi
done

echo ""
