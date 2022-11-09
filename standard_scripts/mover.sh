#!/usr/bin/env bash

# Move all or some specifies scripts to the PATH directories.

program_name=$(basename ${0})

verify_privileges() {
        if [ ${UID} -eq 0 ]; then
                echo -e "ERROR: Run this program without privileges!\nExiting..."
                exit 1
        fi
}

print_usage() {
        echo -e "Run:\n\tTo move all: ${program_name}\n\tTo move some scripts: ${program_name} script_name_1.sh script_name_2.sh"
}

verify_privileges

[ "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>>>> PROGRAM START <<<<<

git_url='https://raw.githubusercontent.com/rhuan-pk/comandos-linux/master/standard_scripts/.pessoal/setload.sh'
std_scripts_path=${PK_LOAD_LINUXCOMMANDS:-$(wget -qO - $git_url | bash - 2>&- | grep -F comandos-linux)/standard_scripts}

[ ${#} -eq 0 ] && {
	for file in ${std_scripts_path}/*.sh; do
		sudo cp -v ${file} /usr/local/bin/$(basename ${file%.*})
	done
} || {
	for file in ${@}; do
		if ! sudo cp -v ${std_scripts_path}/${file} /usr/local/bin/${file%.*}; then
			print_usage
			exit 1
		fi
	done
}
