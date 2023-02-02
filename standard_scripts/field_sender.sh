#!/usr/bin/env bash

# Send the desired message to the informed "dontpad.com".

# >>> variable declarations !

this_script=$(basename "${0}")
home=${HOME:-/home/${USER:-$(whoami)}}

# >>> function declarations !

verify_privileges() {
	[ $UID -eq 0 ] && {
		echo -e "ERROR: Run this program without privileges!\nExiting..."
		exit 1
	}
}

print_usage() {
	cat <<- eof
		####################################################################################################
		#
		# >>> $this_script !
		#
		# Envia texto pleno como dado para o campo do HTML no endereço passado.
		#
		# Informe como:
		# 	- primeiro argumento: <message>
		# 	- segundo argumento: <url>
		# 	- terceiro argumento: <field>
		#
		# Opções (opcionais):
		# 	-a: apenda o conteúdo no final.
		# 	-c: ver para limpar os arquivos de log de conteúdo.
		# 	-h: printa esse menu de ajuda e sai com 1.
		#
		# Exemplo:
		# 	$this_script 'any message to send' 'http://dontpad.com/any' [<id_field_name>]
		#
		####################################################################################################
	eof
}

# >>> pre statements !

set +o histexpand

verify_privileges
[ $# -lt 1 -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

while getopts 'ach' opt; do
	case $opt in
		a) flag_old_text=true;;
		c) flag_clean_files=true;;
		h) print_usage; exit 1;;
		?) print_usage; exit 1;;
	esac
done

shift $((${OPTIND}-1))

# ********** Declaração de Funções **********

make_directory() {
	[ ! -d $sender_path ] && mkdir -v $sender_path
}

next_file() {
	if ! query=$(find ${sender_path} -type f -name "${route_user}*"); then
		echo ${route_user}_$(date +%d-%m-%Y)_1.txt
	else
		basenamed_query=$(
			cat <<- eof
				$(
					for file in $(tr ' ' '\n' <<< ${query}); do
						basename "${file}"
					done
				)
			eof
		)
		next_count=$(sort -t '_' -k 3 -n <<< ${basenamed_query} | tail -1 | cut -d '_' -f 3)
		echo ${route_user}_$(date +%d-%m-%Y)_$((${next_count%.*}+1)).txt
	fi
}

get_old_text() {
	lines=$(grep -nE '(<textarea id="text">|</textarea>)' $sender_full_path | cut -d ':' -f 1 | tr '\n' ',' | sed 's/,$//')
	if ${flag_old_text:-false}; then
		echo $(sed -n "${lines}p" $sender_full_path | sed -E 's/[[:blank:]]*<textarea id="text">|<\/textarea>//g')
	fi
}

clean_files() {
	du -shc ${sender_path}/* 2>&-
	read -p 'Excluir todos os arquivos de log? [y/N] ' answer
	[ ${answer,,} = 'y' ] 2>&- && rm -vf ${sender_path:?$(echo -e $'\e[1;31mcritical var not definied!\e[m')}/*
}

# ********** Declaração de Variáveis **********

message="${1}"
url="${2}"
field="${3:-text}"
route_user=$(cut -d '/' -f 4 <<< ${url})
sender_path=${HOME:-"/home/${USER:-$(whoami)}"}/.dontpad_send
sender_full_path=${sender_path}/$(next_file)

# ********** Início do Programa **********

if ${flag_clean_files:-false}; then clean_files; exit 0; fi
make_directory
curl -s $url > $sender_full_path
curl -d "${field}=$(get_old_text ${flag_old_text})${message}" $url
