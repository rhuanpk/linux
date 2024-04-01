#!/usr/bin/bash

# Print network informations.

# >>> variables declaration!
readonly version='1.0.0'
readonly script="`basename "$0"`"
readonly uid="${UID:-`id -u`}"

SUDO='sudo'

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Print network informations.

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
		echo "$script: error: run with root privileges"
		exit 1
	elif ! "$FLAG_SUDO"; then
		if "$FLAG_ROOT" || [ "$uid" -eq 0 ]; then
			unset SUDO
		fi
	fi
}

check-needs() {
	privileges false false
	PACKAGES=('network-manager')
	for package in "${PACKAGES[@]}"; do
		if ! dpkg -s "$package" &>/dev/null; then
			read -p "$script: info: is needed the \"$package\" package, install? [Y/n] " answer
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
while :; do
	SEPARATOR="$(printf -- '*%.0s' $(seq '0' "$(("`tput cols`"-2))"))"

	SSID="`nmcli -g 'NAME' connection show --active | sed -n '1p'`"
	BSSID="`nmcli -g 802-11-wireless.seen-bssids connection show "$SSID" | tr -d '\\' | cut -d ',' -f 1`"
	IFNAME="`nmcli -g 'GENERAL.TYPE,GENERAL.DEVICE' device show | grep -A1 '^wifi$' | sed -n '2p'`"

	clear

	echo '> ip -br -c a'
	ip -br -c a

	echo -e "\n$SEPARATOR\n\n> nmcli connection show --active"
	nmcli connection show --active

	echo -e "\n$SEPARATOR\n\n> nmcli device wifi list bssid \"$BSSID\" ifname \"$IFNAME\""
	nmcli device wifi list bssid "$BSSID" ifname "$IFNAME"

	echo -e "\n$SEPARATOR\n\n> ping -c 1 'linux.org'"
	ping -c 1 'linux.org'

	tput cup `tput cols` 0
	sleep 3
done
