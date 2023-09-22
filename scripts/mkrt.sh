#!/usr/bin/bash

# Use `mkdir` and return the path (that was created or that already exists).

# >>> variable declarations !
SCRIPT=`basename "$0"`
#HOME=${HOME:-/home/${USER:-`id -un`}}

# >>> function declarations !
verify-privileges() {
       [ "${UID:-`id -u`}" -eq 0 ] && {
               echo -e "ERROR: Run this program without privileges!\nExiting..."
               exit 1
       }
}

print-usage() {
        echo -e "Run:\n\t$SCRIPT <folder>"
}

# >>> pre statements !
set +o histexpand

#verify-privileges
[ "$#" -ge 2 -o "$#" -lt 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print-usage
        exit 1
}

# >>> *** PROGRAM START *** !
PATHSPEC=${1:?need a pathway to create}
[[ "$PATHSPEC" =~ / ]] && {
	echo "$SCRIPT: pathway cannot have depth!"
	exit 2
}
mkdir -v "$PATHSPEC" 2>&1 | sed -nE "s~^.*['‘](.*)['’].*$~\1~p"
