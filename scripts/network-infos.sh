#!/usr/bin/bash

# Print network informations.

# >>> variables declaration!
readonly version='1.1.0'
readonly script="`basename "$0"`"

SUDO='sudo'

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Print network informations.

Usage: $script [<options>]

Options:
	-p: Print once without looping;
	-v: Print version;
	-h: Print this help.
EOF
}

# >>> pre statements!
while getopts 'pvh' option; do
	case "$option" in
		p) FLAG_BREAK=true;;
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
FORMAT='\033[1;3m'
UNFORMAT='\033[m'

while :; do
	SEPARATOR="\033[2;3m$(printf -- '*%.0s' $(seq '0' "$(("`tput cols`"-2))"))\033[m"

	#SSID="`nmcli -t -f 'NAME,TYPE' conn show --active | grep -vE '(vpn|tun|wireg|loop|brid)' | cut -d':' -f1`"
	#BSSID="`nmcli -t -f 802-11-wireless.seen-bssids conn show "$SSID" | cut -d':' -f2- | cut -d',' -f1`"
	#IFNAME="`nmcli -g 'GENERAL.TYPE,GENERAL.DEVICE' device show | grep -A1 '^wifi$' | sed -n '2p'`"

	clear

	echo -e "$FORMAT> ip -br -c a$UNFORMAT"
	ip -br -c a

	echo -e "\n$SEPARATOR\n\n$FORMAT> ip route$UNFORMAT"
	ip route

	if which -s nmcli; then
		echo -e "\n$SEPARATOR\n\n$FORMAT> nmcli connection show --active$UNFORMAT"
		nmcli connection show --active
	fi

	#echo -e "\n$SEPARATOR\n\n$FORMAT> nmcli device wifi list bssid \"$BSSID\" ifname \"$IFNAME\"$UNFORMAT"
	#nmcli device wifi list bssid "$BSSID" ifname "$IFNAME"

	echo -e "\n$SEPARATOR\n\n$FORMAT> ping -c 1 'kernel.org'$UNFORMAT"
	ping -c 1 'kernel.org'

	#echo

	if ${FLAG_BREAK:-false}; then
		break
	fi

	#tput cup `tput cols` 0

	sleep 3
done
