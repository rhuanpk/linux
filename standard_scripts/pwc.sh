#!/usr/bin/env bash

# Tira prints com o scrot e já manda pro diretório correto

verify_privileges() {
        if [ ${UID} -eq 0 ]; then
                echo -e "ERROR: Run this program without privileges!\nExiting..."
                exit 1
        fi
}

print_usage() {
        echo -e "Run:\n\t./$(basename ${0})"
}

verify_privileges

[ "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>>>> PROGRAM START <<<<<

# args_arr=(${*})
declare -a args_arr=${*}
declare -i seconds=${args_arr[0]}
[ ! ${seconds} -ge 1 ] && seconds=1

scrot \
	-d ${seconds} \
	"${args_arr[@]:1}" \
	-e 'xclip -selection clipboard -target image/png $f'
