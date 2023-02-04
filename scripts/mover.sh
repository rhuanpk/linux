#!/usr/bin/env bash

# Move all or some specifies scripts to the PATH directories.

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
        echo -e "Run:\n\tTo move all: ${this_script}\n\tTo move some scripts: $this_script script_name_1.sh script_name_2.sh"
}

# >>> pre statements !

set +o histexpand

verify_privileges
[ "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>> *** PROGRAM START *** !

git_url='https://raw.githubusercontent.com/rhuan-pk/linux/master/scripts/.private/setload.sh'
std_scripts_path=${PK_LOAD_LINUXCOMMANDS:-$(wget -qO - $git_url | bash - 2>&- | grep -F linux)}
[ -z $std_scripts_path ] && std_scripts_path=$(pwd)
std_scripts_path+=/scripts

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
