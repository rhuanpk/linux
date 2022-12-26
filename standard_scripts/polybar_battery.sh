#!/usr/bin/env bash

# Prints the battery percentage if it is "ac adapter".

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

ac_adapter=$(acpi --ac-adapter 2>&1 | tr -d '[[:blank:]]' | cut -d ':' -f 2)
[ "${ac_adapter}" = 'power_supply' ] && is_power_supply=true

if ! ${is_power_supply:-false}; then
	battery_percent=$(acpi | tr -d '[[:blank:]]' | cut -d ',' -f 2)
	echo "| Battery: ${battery_percent:-0%} "
fi
