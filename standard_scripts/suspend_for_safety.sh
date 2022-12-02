#!/usr/bin/env bash

# sudo apt install sudo acpi libnotify-bin -y
# sudo visudo -f /etc/sudoers.d/users
#    > "rhuan ALL=NOPASSWD:/usr/bin/systemctl"
# */2 * * * * /usr/local/bin/pk/suspend_for_safety 2>/tmp/cron_error.log

# Checks the battery percentage, if it is 9% or less the system is suspended.

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

# cron: */2 * * * * export DISPLAY=:0; /usr/local/bin/pk/suspend_for_safety 2>/tmp/cron_error.log
# export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus

battery_power=$(acpi | tr -d '[[:blank:]]' | cut -d ',' -f 2)
[ "$(acpi --ac-adapter | tr -d '[[:blank:]]' | cut -d ':' -f 2)" = 'on-line' ] && is_pluged=true || is_pluged=false

if ! ${is_pluged}; then
	if [ ${battery_power%\%} -le 9 ]; then
		sudo systemctl suspend
	elif [ ${battery_power%\%} -le 11 ]; then
		notify-send 'Battery Power low!' "Low battery: ${battery_power} or less, plug it into outlet."
	fi
fi
