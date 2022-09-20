#!/usr/bin/env bash

# Retorna a conversão do argumento passado em string, seja int, float, string ou arquivo

verify_privileges() {
        if [ ${UID} -eq 0 ]; then
                echo -e "ERROR: Run this program without privileges!\nExiting..."
                exit 1
        fi
}

print_usage() {
        cat <<- eof
		####################################################################################################
		#
		# This program returns the argument casting to a string.
		#
		# Syntax:
		#
		# 	./$(basename ${0}) <unique_argument>
		#
		# E.g.:
		# 	./$(basename ${0}) "{some string|/path/to/file.txt|<integer>|<float>}"
		#
		# Options:
		#
		# 	--help | -h: Print this message and exit with 1.
		#
		####################################################################################################
	eof
}

# verify_privileges

[ ${#} -lt 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>>>> PROGRAM START <<<<<

any="${1}"

[[ -f $any && ! $any =~ [[:blank:]]+ ]] && cat $any || echo $any
