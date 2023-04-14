#!/usr/bin/env bash

# Get links of latest release the archives from github.

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
		##################################################################################
		#
		# >>> $script !
		#
		# DESCRIPTION
		# 	Script that returns all URL's of assets the latest GitHub release passing
		# 	the user and repository as a parameter, e.g. "user/repo".
		#
		# USAGE
		# 	$script user/repo
		#
		##################################################################################
	eof
}

# >>> pre statements !

set +o histexpand

#verify_privileges
[ $# -lt 1 -o $# -gt 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>> *** PROGRAM START *** !
user_and_repo=${1:?needs a user and repo to search!}
curl -sSL https://api.github.com/repos/"$user_and_repo"/releases/latest \
	| sed -nE 's/.*"browser_download_url": "(.*)".*/\1/p'
