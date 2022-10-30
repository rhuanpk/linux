#!/usr/bin/env bash

# sc2cb = Send Color to ClipBoard
# Sends the hex code of the color to your clipboard.

verify_privileges() {
        if [ ${UID} -eq 0 ]; then
                echo -e "ERROR: Run this program without privileges!\nExiting..."
                exit 1
        fi
}

print_usage() {
        echo -e "Run:\n\t./$(basename ${0})"
}

# verify_privileges

[ ${#} -ge 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>>>> PROGRAM START <<<<<

echo \#$(colorpicker --one-shot --short | cut -d '#' -f 2) | tr -d '\n' | xsel -b
