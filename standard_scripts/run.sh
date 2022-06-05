#!/usr/bin/env bash

# Automatically compiles and executes a .java file, just pass the file name as a parameter

verify_privileges() {
        if [ ${UID} -eq 0 ]; then
                echo -e "ERROR: Run this program without privileges!\nExiting..."
                exit 1
        fi
}

print_usage() {
        cat <<- EOF
		##############################################################################################
		#
		# Run the program passing as a parameter the name of the file without the extension, example:
		#
		# ./$(basename ${0}) file
		#
		##############################################################################################
	EOF
}

verify_privileges

[ ${#} -lt 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>>>> PROGRAM START <<<<<

javac "${1}.java"
java "${1}"
