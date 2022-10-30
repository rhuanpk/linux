#!/usr/bin/env bash

# Set a new binding for gnome environments.

verify_privileges() {
        if [ ${UID} -eq 0 ]; then
                echo -e "ERROR: Run this program without privileges!\nExiting..."
                exit 1
        fi
}

print_usage() {
        cat <<- EOF
		#######################################################################
		#
		# >>> $(basename ${0^^})!
		#
		# Set a new binding passing the following params:
		#
		# 1. Name of binding
		# 2. Description of binding
		# 3. Binding
		# 4. Command which call the binding
		#
		# Example:
		#
		# 	$(basename ${0}) volume0 'Volume control' '<Alt>v' vcontrol.sh
		#
		#######################################################################
	EOF
}

verify_privileges

[ ${#} -lt 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>>>> PROGRAM START <<<<<

custom_keybinding="${1}"
name_keybinding="${2}"
binding_keybinding="${3}"
command_keybinding="terminator --borderless --geometry=175x30-0-0 --command=${4}"

existing_keybindins=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings | sed 's/]$/, /')
[ ${#existing_keybindins} -le 10 ] && existing_keybindins=[
new_keybinding="'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${custom_keybinding}/'"
complete_keybinding=${existing_keybindins}${new_keybinding}]

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "${complete_keybinding}"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${custom_keybinding}/ name "${name_keybinding}"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${custom_keybinding}/ binding "${binding_keybinding}"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${custom_keybinding}/ command "${command_keybinding}"
