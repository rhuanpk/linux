#!/usr/bin/bash

# Prints the local ip for polybar module.

# >>> variables declaration!
readonly version='1.1.0'
readonly script="`basename "$0"`"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Prints the local ip for polybar module.

Usage: $script [<options>]

Options:
	-v: Print version;
	-h: Print this help.
EOF
}

# >>> pre statements!
while getopts 'vh' option; do
	case "$option" in
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
# check if ifname is present
check-ifname() {
	local proc_file="${1:?need file to check}"
	grep -qF "$ifname" "$proc_file"
}

# set signal file
readonly sig='/tmp/pns.sig'
sig_state="`[ -f "$sig" ] && wc -l < "$sig"`"

# get interface routes
route="$(ip route | grep '^default.*metric' | cut -d' ' -f'5,9,11' | sort -n -t' ' -k3 | head -1)"

# set interface name
ifname="$(cut -d' ' -f1 <<< "$route")"
: ${ifname:=tux}

# set ip address
ip="$(cut -d' ' -f2 <<< "$route")"
: ${ip:=N/I}

# set interface type
if check-ifname /proc/net/wireless; then
	iftype='w_IP'
elif check-ifname /proc/net/dev; then
	iftype='e_IP'
else
	iftype='Network'
fi

[ "${sig_state:=0}" -eq 1 ] && {
	if [ "$iftype" = 'w_IP' ]; then
		if which -s nmcli; then
			ssid="$(nmcli -t -f name,device conn show --active | grep -F "$ifname" | cut -d':' -f1)"
		#elif which -s iwgetid; then
		#	ssid="$(iwgetid -r)"
		#elif which -s iwconfig; then
		#	ssid="$(iwconfig "$ifname" | sed -nE 's/^.*ESSID:"(.*)".*$/\1/p')"
		fi
		[ "$ssid" ] && ip+=" %{F#555555}-%{F-} %{F#FF00FF}$ifname:%{F-} $ssid"
	elif [ "$iftype" = 'e_IP' ]; then
		ip+=" %{F#555555}-%{F-} %{F#FF00FF}$ifname%{F-}"
	fi
}
[ "$sig_state" -ge 2 ] && rm "$sig"
if pvs; then
	ip+=' (%{F#FF00FF}VPN%{F-})'
fi
echo "%{F#10E3E3}$iftype:%{F-} $ip"
