#!/bin/bash

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
