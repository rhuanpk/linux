#!/usr/bin/bash

# >>> variables declaration!
readonly version='1.2.0'
readonly script="$(basename "$0")"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

DESCRIPTION
	Build a new tmux session with a preseted layout for git propouses.

USAGE
	$script [<options>]

OPTIONS
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

#loop() {
#	local project="${1:?need project folder}"
#	local command="${2:?need command}"
#	cd $project \
#	&& while :; do
#		clear
#		eval ${command@Q}
#		sleep 1
#	done
#}

loop() {
	local command="${1:?need command}"
	echo "while :; do clear; $command; sleep 1; done"
}

# >>> pre statements!
while getopts 'srvh' option; do
	case "$option" in
		s) privileges true false;;
		r) privileges false true;;
		v) echo "$version"; exit 0;;
		h) usage; exit 1;;
		*) exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
project="${1:?need project folder}"
project="${project%/}"
tmux \;\
	new-session -d -s "$(basename ${project/%./$(pwd)})" \;\
	send-keys "cd ${project@Q}/ && $(loop 'git log -a -10 --oneline --graph')" C-m \;\
	split-window -v \;\
	send-keys "cd ${project@Q}/" C-m \;\
	split-window -v \;\
	send-keys "cd ${project@Q}/" C-m \;\
	split-window -h -t '.1' \;\
	send-keys "cd ${project@Q}/ && $(loop 'git diff')" C-m \;\
	split-window -h -t '.0' \;\
	send-keys "cd ${project@Q}/ && $(loop 'git status')" C-m \;\
