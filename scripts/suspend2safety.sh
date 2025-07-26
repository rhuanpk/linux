#!/usr/bin/bash

# Checks the battery percentage and suspend for safety when necessary.

# >>> built-in sets!
set -e +o histexpand

# >>> variables declaration!
readonly version='1.1.0'
readonly script="`basename "$0"`"
readonly uid="${UID:-`id -u`}"

SUDO='sudo'
BATTERY_POWER="`acpi | tr -d '[[:blank:]]' | cut -d ',' -f 2`"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Checks the battery percentage, if it is 9% or less the system is suspended.

Usage: $script [<options>]

Options:
	-v: Print version;
	-h: Print this help.
EOF
}

privileges() {
	FLAG_SUDO="${1:?needs sudo flag}"
	FLAG_ROOT="${2:?needs root flag}"
	if [[ -z "$SUDO" && "$uid" -ne 0 ]]; then
		echo "$script: run with root privileges"
		exit 1
	elif ! "$FLAG_SUDO"; then
		if "$FLAG_ROOT" || [ "$uid" -eq 0 ]; then
			unset SUDO
		fi
	fi
}

check-needs() {
	privileges false false
	PACKAGES=('acpi' 'libnotify-bin')
	for package in "${PACKAGES[@]}"; do
		if ! dpkg -s "$package" &>/dev/null; then
			read -p "$script: is needed the \"$package\" package, install? [Y/n] " answer
			[ -z "$answer" ] || [ 'y' = "${answer,,}" ] && $SUDO apt install -y "$package"
		fi
	done
}

# >>> pre statements!
check-needs

while getopts 'vh' option; do
	case "$option" in
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
# cron: * * * * * export DISPLAY=:0; /usr/local/bin/pk/suspend2safety 2>/tmp/cron_error.log
# export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/`id -u`/bus

notify() {
	local urgency="${1:-normal}"
	notify-send -u "$urgency" 'Battery Power!' "Low battery: $BATTERY_POWER or less, plug it into outlet."
}

[ "`acpi --ac-adapter | tr -d '[[:blank:]]' | cut -d ':' -f 2`" = 'on-line' ] && IS_PLUGED='true' || IS_PLUGED='false'

if ! "$IS_PLUGED"; then
	if [ "${BATTERY_POWER%\%}" -le '9' ]; then
		notify critical
		if [ "${BATTERY_POWER%\%}" -le '7' ]; then
			#polybar-msg action '#dunst.hook.1'
			#dunstctl set-paused 'true'
			#wpctl set-mute '@DEFAULT_AUDIO_SINK@' 1
			systemctl hibernate
		fi
	elif [ "${BATTERY_POWER%\%}" -le '11' ]; then
		notify
	fi
fi
