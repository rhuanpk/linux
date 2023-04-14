#!/usr/bin/env bash

# Starts a single instance of ssh-agent (needs run this script in news shells instances).

# >>> variable declarations !

script=$(basename "${0}")
home=${HOME:-/home/${USER:-$(whoami)}}

# >>> function declarations !

verify_privileges() {
	[ $UID -eq 0 ] && {
		echo -e "ERROR: Run this program without privileges!\nExiting..."
		exit 1
	}
}

print_usage() {
        echo -e "Run:\n\t./${script}"
}

# >>> pre statements !

set +o histexpand

#verify_privileges
[ $# -ge 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>> *** PROGRAM START *** !
XDG_CONFIG_SSH=$HOME/.config/ssh
ssh_pid_file=$XDG_CONFIG_SSH/ssh-agent.pid
SSH_AUTH_SOCK=$XDG_CONFIG_SSH/ssh-agent.sock

ssh_agent_infos() {
	echo "'$SSH_AUTH_SOCK' ($SSH_AGENT_PID)"
}

[ ! -d "$XDG_CONFIG_SSH" ] && mkdir -pv "$XDG_CONFIG_SSH"

SSH_AGENT_PID=`cat "$ssh_pid_file"`
if ! kill -0 $SSH_AGENT_PID 2>&-; then
	rm -f "$SSH_AUTH_SOCK"
	echo "starting ssh-agent, since it's not running!"
	eval "`ssh-agent -sa "$SSH_AUTH_SOCK"`"
	echo $SSH_AGENT_PID > "$ssh_pid_file"
	echo "started ssh-agent with `ssh_agent_infos`"
else
	echo "ssh-agent already started on `ssh_agent_infos`"
	export SSH_AGENT_PID
	export SSH_AUTH_SOCK
fi
