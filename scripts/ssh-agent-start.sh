#!/usr/bin/bash

# >>> built-in setups
set -e

# >>> variables declaration
readonly version='2.1.0'
readonly script="$(basename "$0")"
readonly uid="${UID:-$(id -u)}"

# >>> functions declaration
usage() {
cat << EOF
$script v$version

DESCRIPTION
	Starts a single instance of ssh-agent. Check if already exists an agent and set the env vars to this one, case not exists, starts a new one.

USAGE
	eval \`$script [<options>]\`

OPTIONS
	-x
		Kill all agents (\`killall -e ssh-agent') and remove all socks (\`rm -rfv /tmp/ssh-*').
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

# >>> pre statements
privileges

while getopts 'xsrvh' option; do
	case "$option" in
		x) flag_delete=true;;
		s) privileges true false;;
		r) privileges false true;;
		v) echo "$version"; exit 0;;
		h) usage; exit 1;;
		*) exit 2;;
	esac
done
shift $((OPTIND-1))

# ***** PROGRAM START *****
ssh-agent-infos() {
	echo "agent=${SSH_AGENT_PID@Q};socket=${SSH_AUTH_SOCK@Q}"
}

#[ -z "$SSH_AGENT_PID" ] && SSH_AGENT_PID="$(pgrep -fn /usr/bin/ssh-agent)"

# maybe this env vars can be wrong?
#[ -z "$SSH_AGENT_PID" ] && SSH_AGENT_PID="$(pgrep -xn ssh-agent)"
#[ -z "$SSH_AUTH_SOCK" ] && SSH_AUTH_SOCK="$(ls -1t /tmp/ssh-*/* 2>&- | head -1)"

SSH_AGENT_PID="$(pgrep -xn ssh-agent)"
SSH_AUTH_SOCK="$(ls -1t /tmp/ssh-*/* 2>&- | head -1)"

if "${flag_delete:-false}"; then
	killall -e ssh-agent
	rm -rfv /tmp/ssh-*
fi

if \
	kill -0 "$SSH_AGENT_PID" 2>&- \
	&& [ -S "$SSH_AUTH_SOCK" ] \
	&& [ "$($sudo lsof -tau "${USER:-$(id -un)}" "$SSH_AUTH_SOCK")" = "$SSH_AGENT_PID" ] \
; then
	cat <<- EOF
		echo "$script: already started";
		echo "$(ssh-agent-infos)";
		export SSH_AGENT_PID='$SSH_AGENT_PID';
		export SSH_AUTH_SOCK='$SSH_AUTH_SOCK';
	EOF
else
	eval "$(ssh-agent -s)" >/dev/null
	cat <<- EOF
		echo "$script: starting";
		echo "$script: started";
		echo "$(ssh-agent-infos)";
		export SSH_AGENT_PID='$SSH_AGENT_PID';
		export SSH_AUTH_SOCK='$SSH_AUTH_SOCK';
	EOF
fi
