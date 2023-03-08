#!/usr/bin/env bash

# Returns the conversion of the passed argument to string, whether int, float, string, or file.

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
        cat <<- eof
		####################################################################################################
		#
		# This program returns the argument casting to a string.
		#
		# Syntax:
		#
		# 	./${script} <unique_argument>
		#
		# E.g.:
		# 	./${script} "{some string|/path/to/file.txt|<integer>|<float>}"
		#
		# Options:
		#
		# 	-h: Print this message and exit with 1.
		#
		####################################################################################################
	eof
}

# >>> pre statements !

set +o histexpand

#verify_privileges
#[ $# -lt 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
#        print_usage
#        exit 1
#}

# >>> *** PROGRAM START *** !
while getopts 'hf' opt; do
	case $opt in
		h) print_usage; exit 0;;
		# f) file_convert=true;;
		?) print_usage; exit 1;;
	esac
done
shift $((${OPTIND}-1))

any="${1}"
[[ -f $any && ! $any =~ [[:blank:]]+ ]] && cat $any || echo $any
