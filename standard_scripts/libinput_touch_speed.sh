#!/usr/bin/env bash

# Diminúi ou aumenta velocidade do ponteiro

verify_privileges() {
        if [ ${UID} -eq 0 ]; then
                echo -e "ERROR: Run this program without privileges!\nExiting..."
                exit 1
        fi
}

print_usage() {
        echo -e "Run:\n\t./$(basename ${0})"
}

verify_privileges

[ ${#} -ge 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>>>> PROGRAM START <<<<<

device_id=$(xinput list --short | grep -iF pointer | grep -iF touchpad | grep -Eio '(id=[[:digit:]]+)' | cut -d '=' -f 2)
property_id=$(xinput list-props $foo | grep -Eio '(Accel Speed \([[:digit:]]+)' | cut -d '(' -f 2)
old_value=$(xinput list-props $foo | grep -Ei '(Accel Speed \()' | tr -d '[[:blank:]]' | cut -d ':' -f 2 | grep -Eio '^([[:digit:]]{1}\.[[:digit:]]{1})')
xinput set-prop $foo $bar 1
