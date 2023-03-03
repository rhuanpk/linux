#!/usr/bin/env bash

# This script decompress most popular compress extensions,
# creating a folder with same name of the file then decompress
# inside her.

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

for file in $(ls -1); do

	extension=$(grep -oE '(\.[^[[:digit:]]]*.*)$' <<< ${file})
	folder=$(cut -d '.' -f 1 <<< ${file})

	mkdir ./${folder}/
	mv ./${file} ./${folder}/
	cd ./${folder}/

	if [ $extension = '.tar.gz' ]; then
		tar -zxvf ./${file}
	elif [[ $extension =~ ^.(tar|tbz2)(.(xz|bz2))?$ ]]; then
		tar -xvf ./${file}
	elif [ $extension = '.zip' ]; then
		unzip ./${file}
	fi

	cd ../

done
