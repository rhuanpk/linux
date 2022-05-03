#!/usr/bin/env bash

# sudo apt install sudo acpi notify-send -y
# sudo visudo -f /etc/sudoers.d/users
# >>> "rhuan ALL=NOPASSWD:/usr/bin/systemctl"

battery_power=$(acpi -b | cut -d ',' -f '2' | sed 's/ \|%//g')

[ ${battery_power} -le 7 ] && sudo systemctl suspend || [ ${battery_power} -le 9 ] && notify-send 'Battery Power low\'s!' 'Low battery: 98%, plug it into outlet.'
