#!/usr/bin/env bash

# Move all or some specifies scripts to the PATH directories

verify_privileges() {
        if [ ${UID} -eq 0 ]; then
                echo -e "ERROR: Run this program without privileges!\nExiting..."
                exit 1
        fi
}

print_usage() {
        echo -e "Run:\n\tTo move all: ./${program_name}\n\tTo move some scripts: ./${program_name} backup.sh bcontrol.sh"
}

program_name=$(basename ${0})

verify_privileges

[ "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>>>> PROGRAM START <<<<<

std_scripts_path=${HOME}/Documents/git/comandos-linux/standard_scripts

[ ! -d ${std_scripts_path} ] && std_scripts_path=$(pwd)

[ ${#} -eq 0 ] && sudo cp -v ${std_scripts_path}/*.sh /usr/local/bin/ || {
	for file in ${@}; do
		if ! sudo cp -v ${std_scripts_path}/${file} /usr/local/bin/; then
			print_usage
			exit 1
		fi
	done
}
