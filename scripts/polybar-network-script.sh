#!/usr/bin/bash

# Prints the local ip for polybar module.

# >>> variables declaration!
readonly version='1.0.0'
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
readonly TMP_FILE='/tmp/pns.sig'
TMP_FILE_STATE="`[ -f "$TMP_FILE" ] && wc -l < "$TMP_FILE"`"
INTERFACE="`ip a | grep -Em1 -A3 '[[:digit:]]+: (eth|enp|wl).*state UP'`"
IP="`sed -nE 's/^.*inet (([[:digit:]]{1,3}.?){4})\/.*$/\1/p' <<< "$INTERFACE"`"
[ -n "$INTERFACE" ] && {
	if nmcli -g 'TYPE,STATE' device status | grep -qF 'ethernet:connected'; then
		TYPE='e_IP'
	else
		TYPE='w_IP'
	fi
} || TYPE='Network'
[ -z "$IP" ] && IP='N/A'
[ "${TMP_FILE_STATE:=0}" -eq 1 ] && {
	IP+=" %{F#555555}-%{F-} `nmcli -t -f active,ssid device wifi | sed -nE 's/^yes:(.*)$/\1/p'`"
}
[ "$TMP_FILE_STATE" -ge 2 ] && rm "$TMP_FILE"
if pvs; then
	IP+=' (%{F#FF00FF}VPN%{F-})'
fi
echo "%{F#10E3E3}$TYPE:%{F-} $IP"
