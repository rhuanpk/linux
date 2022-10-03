#!/usr/bin/env bash

# Envia notificação para a área de trabalho para lembra do todo list

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

[ ${#} -ge 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>>>> PROGRAM START <<<<<

# cron: 0 * * * * export DISPLAY=:0; /usr/local/bin/pk-todo_notify 2>/tmp/cron_error.log

home=${HOME:-"/home/${USER:-$(whoami)}"}
todo_list_path_file=${home}/Documents/anotacoes/.todo_list.txt

[ -s ${todo_list_path_file} ] && {
        message=$(cat ${todo_list_path_file})
        notify-send '>>> ToDo List !' "${message}"
}
