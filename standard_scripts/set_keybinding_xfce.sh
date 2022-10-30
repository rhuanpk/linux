#!/usr/bin/env bash

# Reset and set as new keybing for xfce environments.

verify_privileges() {
        if [ ${UID} -eq 0 ]; then
                echo -e "ERROR: Run this program without privileges!\nExiting..."
                exit 1
        fi
}

print_usage() {
	cat <<- EOF
		#######################################################################
		#
		# >>> $(basename ${0^^})!
		#
		# Set a new binding passing the following params for xfce systems:
		#
		# 1. Binding
		# 2. Command
		#
		# Example:
		#
		# 	$(basename ${0}) '<Alt>v' vcontrol.sh
		#
		# For remove a binding pass only a param:
		#
		# 1. Binding
		#
		# Example:
		#
		# 	$(basename ${0}) '<Alt>v'
		#
		#######################################################################
	EOF
}

verify_privileges

[ ${#} -lt 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>>>> PROGRAM START <<<<<

xfconf-query --reset --channel xfce4-keyboard-shortcuts --property "/xfwm4/custom/${1}"
xfconf-query --reset --channel xfce4-keyboard-shortcuts --property "/commands/custom/${1}"
[ ${#} -ge 2 ] && xfconf-query --create --channel xfce4-keyboard-shortcuts --property "/commands/custom/${1}" --type string --set "${2}"
