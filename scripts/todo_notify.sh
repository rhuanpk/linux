#!/usr/bin/env bash

# Send notification to desktop to remind todo list.

# >>> variable declarations !

script=$(basename "${0}")
home=${HOME:-/home/${USER:-$(whoami)}}

# >>> function declarations !

verify_privileges() {
	[ $UID -eq 0 ] && {
		echo -e "ERROR: Run this program without privileges!\nExiting..."
		exit 1
	}
}

print_usage() {
        echo -e "Run:\n\t./${script}"
}

# >>> pre statements !

set +o histexpand

verify_privileges
[ $# -ge 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>> *** PROGRAM START *** !

# cron: 0 * * * * export DISPLAY=:0; /usr/local/bin/pk/todo_notify 2>/tmp/cron_error.log

home=${HOME:-"/home/${USER:-$(whoami)}"}
todo_list_path_file=${home}/Documents/anotacoes/.todo_list.txt

[ -s ${todo_list_path_file} ] && {
        message=$(cat ${todo_list_path_file})
        notify-send '>>> ToDo List !' "${message}"
}
