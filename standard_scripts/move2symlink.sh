#!/usr/bin/env bash

# OBS: Sempre que adicionar uma nova função, adicionar no array "all_functions"

# ********** Declaração de Funções **********

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
		sudo ln -sv ${file} /usr/local/bin/pk-$(basename ${file%.sh})
	done
}

copy2binarie() {
	for file in $(egrep "${expression}" <<< ${all_files}); do
		sudo cp -v ${file} /usr/local/bin/pk-$(basename ${file%.sh})
	done
}

# ********** Declaração de Variáveis **********

all_files=$(ls -1 ~/Documents/git/comandos-linux/standard_scripts/*.sh)
expression='(backup|pick_bkp_file|push_script)\.sh'
all_functions=("copy2symlink" "copy2binarie")

# ********** Início do Programa **********

case "${1}" in
	"") ${all_functions[@]};;
	--only-symlink) ;;
	-h | --help) print_usage;;
	*) print_usage;;
esac
