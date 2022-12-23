#!/usr/bin/env bash

# Decrease or increase pointer speed.

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

get_device_id() {
	device=$1
	echo "$(xinput list --short | grep -iF pointer | grep -iF $device | grep -Eio '(id=[[:digit:]]+)' | cut -d '=' -f 2)"
}

get_old_value() {
	echo "$(xinput list-props $device_id | grep -Ei '(Accel Speed \()' | tr -d '[[:blank:]]' | cut -d ':' -f 2 | grep -Eio '^([[:digit:]]{1}\.[[:digit:]]{1})')"
}

operation() {
	signal=$1
	old_value=$(get_old_value)
	[ -z $old_value ] && old_value=0.0
	xinput set-prop $device_id $property_id $(bc <<< "${old_value}${signal}0.1") 2>&-
}

flag=true
device_id=$(get_device_id touchpad)
[ -z $device_id ] && device_id=$(get_device_id mouse)
property_id=$(xinput list-props $device_id | grep -Eio '(Accel Speed \([[:digit:]]+)' | cut -d '(' -f 2)

while $flag; do
	clear
	read -n 1 -p "Speed Pointer: $(get_old_value) [+/-]? " answer
	[ ${answer,,} = 'q' ] && flag=false || {
		if [ $answer = '-' ]; then
			operation $answer
		elif [ $answer = '+' ]; then
			operation $answer
		fi
	}
done
