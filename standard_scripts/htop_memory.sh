#!/usr/bin/env bash

# Take the consumption of ram memory

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

echo "RAM: $(($(free -m | tr -s ' ' | head -n 2 | tail -n 1 | cut -d ' ' -f 3)+100)) mb"
