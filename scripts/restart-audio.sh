#!/usr/bin/bash

# Put this script into '/usr/lib/systemd/system-sleep/'
# and uncomment the line thats check for to arg 1
# in program start to auto exect when system resume.

# >>> variables declaration!
readonly version='1.2.0'
readonly script="$(basename "$0")"
readonly uid="${UID:-$(id -u)}"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

DESCRIPTION
	Reload audio sound card.

USAGE
	$script [<options>]

OPTIONS
	-a
		Restart the pipewire, pipewire-pulse and wireplumber services too.
	-z
		Only executes the \`-a' option.
	-s
		Forces keep sudo.
	-r
		Forces unset sudo.
	-v
		Print version.
	-h
		Print this help.
EOF
}

privileges() {
	local flag_sudo="$1"
	local flag_root="$2"
	sudo='sudo'
	if [[ -z "$sudo" && "$uid" -ne 0 ]]; then
		echo "$script: error: run as root #sudo"
		exit 1
	elif ! "${flag_sudo:-false}"; then
		if "${flag_root:-false}" || [ "$uid" -eq 0 ]; then
			unset sudo
		fi
	fi
}

# >>> pre statements!
privileges

while getopts 'azsrvh' option; do
	case "$option" in
		a) flag_all=true;;
		z) flag_reverse=true;;
		s) privileges true false;;
		r) privileges false true;;
		v) echo "$version"; exit 0;;
		h) usage; exit 1;;
		*) exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
#[ "$1" = 'post' ] || exit 0
if "${flag_reverse:-false}"; then
	systemctl --user restart wireplumber pipewire pipewire-pulse
	exit
fi
jack_id="$(lspci | sed -nE 's/^(.*) Audio device: .*$/\1/p')"
if folder_id="$(ls -1 /sys/bus/pci/devices/ | grep -F "${jack_id:?no such audio jack}")"; then
	$sudo tee /sys/bus/pci/devices/"$folder_id"/remove >/dev/null <<< '1'
	$sudo tee /sys/bus/pci/rescan >/dev/null <<< '1'
fi
if "${flag_all:-false}"; then
	systemctl --user restart wireplumber pipewire pipewire-pulse
fi
