#!/usr/bin/bash

# Starts a single instance of ssh-agent (needs run this script in news shells instances).

# >>> built-in sets!
set +o histexpand

# >>> variables declaration!
readonly version='1.1.0'
readonly script="`basename "$0"`"

XDG_CONFIG_SSH="$HOME/.config/ssh"
SSH_PID_FILE="$XDG_CONFIG_SSH/ssh-agent.pid"
SSH_AUTH_SOCK="$XDG_CONFIG_SSH/ssh-agent.sock"
SSH_AGENT_PID="`cat "$SSH_PID_FILE"`"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Starts a single instance of ssh-agent (needs run this script in news shells instances).

Usage: $script [<options>]

Options:
	-v: Print version;
	-h: Print this help.
EOF
}

ssh-agent-infos() {
	echo "'$SSH_AUTH_SOCK' ($SSH_AGENT_PID)"
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
[ ! -d "$XDG_CONFIG_SSH/" ] && mkdir -pv "$XDG_CONFIG_SSH/"

if ! kill -0 "$SSH_AGENT_PID" 2>&-; then
	rm -f "$SSH_AUTH_SOCK"
	echo "starting ssh-agent, since it's not running!"
	eval "`ssh-agent -sa "$SSH_AUTH_SOCK"`"
	echo "$SSH_AGENT_PID" > "$SSH_PID_FILE"
	echo "started ssh-agent with `ssh-agent-infos`"
else
	echo "ssh-agent already started on `ssh-agent-infos`"
	export SSH_AGENT_PID
	export SSH_AUTH_SOCK
fi
