#!/usr/bin/env bash

# OBS: Whenever you add a new function, add it to the "all_functions" array

# ********** Declaração de Funções **********

verify_privileges() {
        if [ ${UID} -eq 0 ]; then
                echo -e "ERROR: Run this program without privileges!\nExiting..."
                exit 1
        fi
}

print_usage() {
	echo -e "\
		\r\t\e[1m*** MOVE2SYMLINK ***\e[m\n\n\
		\r\e[1mUsage\e[m: ./$(basename ${0}) [--ony-symlink]\n\n\
		\r\e[1mDescription\e[m: Move binaries to the \"local/bin\" folder converting symlinks but some not.\n\n\
		\r\e[1mOptions\e[m:\n\
		\r\t--only-symlink: Move only those that will be converted to symlinks.\
	"
}

copy2symlink() {
	for file in $(egrep -v "${expression}" <<< ${all_files}); do
		sudo ln -svf ${file} /usr/local/bin/pk-$(basename ${file%.sh})
	done
}

copy2binarie() {
	for file in $(egrep "${expression}" <<< ${all_files}); do
		sudo cp -v ${file} /usr/local/bin/pk-$(basename ${file%.sh})
	done
}

execute_all() {
	for atual_func in ${all_functions[@]}; do
		${atual_func}
	done
}

# ********** Declaração de Variáveis **********

[ -d ${HOME}/Documents/git/comandos-linux/standard_scripts ] && path=${HOME}/Documents/git/comandos-linux/standard_scripts || path=$(pwd)
all_files=$(ls -1 ${path}/*.sh)
expression='(backup|push_script)\.sh'
all_functions=("copy2symlink" "copy2binarie")

# ********** Início do Programa **********

verify_privileges

case "${1}" in
	"") execute_all;;
	--only-symlink) copy2symlink;;
	-h | --help) print_usage;;
	*) print_usage;;
esac
