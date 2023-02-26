#!/usr/bin/env bash

# OBS: Whenever you add a new function, add it to the "all_functions" array.

# ********** Declaração de Variáveis **********

script=$(basename "${0}")
home=${HOME:-/home/${USER:-$(whoami)}}
git_url='https://raw.githubusercontent.com/rhuan-pk/linux/master/scripts/.private/setload.sh'
path=${PK_LOAD_LINUX:-$(wget -qO - $git_url | bash - 2>&- | grep -F linux)}
[ -z $path ] && path=$(pwd)
path+=/scripts
all_files=$(ls -1 ${path}/*.sh)
expression='(backup|push_script|veu)\.sh'
all_functions=("copy2symlink" "copy2binarie")

# ********** Declaração de Funções **********

verify_privileges() {
	[ $UID -eq 0 ] && {
		echo -e "ERROR: Run this program without privileges!\nExiting..."
		exit 1
	}
}

print_usage() {
	echo -e "\
		\r\t\e[1m*** MOVE2SYMLINK ***\e[m\n\n\
		\r\e[1mUsage\e[m: ./${script} [--ony-symlink]\n\n\
		\r\e[1mDescription\e[m: Move binaries to the \"local/bin\" folder converting symlinks but some not.\n\n\
		\r\e[1mOptions\e[m:\n\
		\r\t--only-symlink: Move only those that will be converted to symlinks.\
	"
}

copy2symlink() {
	for file in $(egrep -v "${expression}" <<< ${all_files}); do
		sudo ln -svf ${file} /usr/local/bin/pk/$(basename ${file%.sh})
	done
}

copy2binarie() {
	for file in $(egrep "${expression}" <<< ${all_files}); do
		sudo cp -v ${file} /usr/local/bin/pk/$(basename ${file%.sh})
	done
}

execute_all() {
	for atual_func in ${all_functions[@]}; do
		${atual_func}
	done
}

# ********** Início do Programa **********

verify_privileges

case "${1}" in
	"") execute_all;;
	--only-symlink) copy2symlink;;
	-h | --help) print_usage;;
	*) print_usage;;
esac
