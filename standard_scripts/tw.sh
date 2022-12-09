#!/usr/bin/env bash

# Take the Window (TK).
# It is software that gives focus to the specified window or executes a command if it is not available.

script=$(basename ${0})

verify_privileges() {
        if [ ${UID} -eq 0 ]; then
                echo -e "ERROR: Run this program without privileges!\nExiting..."
                exit 1
        fi
}

print_usage() {
	cat <<- eof
		####################################################################################################
		#
		# >>> $script !
		#
		# Take the window or execute a command.
		#
		# Syntax:
		# 	$script <window_class> <command_to_execute>
		#
		# E.g.:
		# 	$script '"google-chrome", "Google-chrome"' 'xdotool --clearmodifiers Alt_L+F4'
		#
		# Helps:
		# 	Usually the names placed in <window_class> is the name of the binary and its "formal name",
		# 	sometimes both fields will be the binary name e.g. '"terminator", "terminator"' and
		# 	sometimes both the fields will be the "formal name" e.g. '"DBeaver", "DBeaver"'.
		#
		####################################################################################################
	eof
}

verify_privileges

[ ${#} -gt 3 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>>>> PROGRAM START <<<<<

class_search="${1:?'need a classe to search, e.g. "x-terminal-emulator", "X-terminal-emulator"'}"
command_execute="${2:?'need a command to execute case the window dont visible, e.g. xdotool key --clearmodifiers Control_L+t'}"

id_list=$(xprop -root | sed -nE 's/^_NET_CLIENT_LIST_STACKING\(WINDOW\): window id # (.*)$/\1/p;s/,//')
is_visible=false
sed_command='sed -nE "s/^WM_CLASS\(STRING\) = (.*)/\1/p"'

echo 'windows:'
for id in ${id_list}; do
	window="$(eval "xprop -id $id | ${sed_command}")"
	[ "${window}" = "${class_search}" ] && is_visible=true && window_id=${id}
	echo -e "\t- ${window}"
done

if ! ${is_visible}; then
	eval "${command_execute}"
elif [ "$(eval "xprop -id $(xdotool getactivewindow) | ${sed_command}")" != "${class_search}" ]; then
	xdotool windowactivate $window_id 2>&-
fi
