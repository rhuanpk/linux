#!/usr/bin/env bash

# sudo apt install sudo acpi notify-send -y
# sudo visudo -f /etc/sudoers.d/users
#    > "rhuan ALL=NOPASSWD:/usr/bin/systemctl"
# */2 * * * * /usr/local/bin/pk-suspend_for_safety 2>/tmp/cron_error.log

battery_power=$(acpi -b | cut -d ',' -f '2' | sed 's/ \|%//g')
[ "$(acpi --ac-adapter | tr -d ' ' | cut -d ':' -f '2')" = 'on-line' ] && is_pluged=true || is_pugled=false

if ! ${is_pluged}; then
	if [ ${battery_power} -le 9 ]; then
		sudo systemctl suspend
	elif [ ${battery_power} -le 11 ]; then
		notify-send 'Battery Power low!' 'Low battery: 11% or less, plug it into outlet.'
	fi
fi
