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

# cron: * */1 * * * /usr/local/bin/pk-todo_notify 2>/tmp/cron_error.log

message=$(cat ~/Documents/anotacoes/.todo_list.txt)
notify-send '>>> ToDo List !' "${message}"
