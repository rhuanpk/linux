#!/usr/bin/env bash

custom_keybinding=${1}
name_keybinding=${2}
binding_keybinding=${3}
command_keybinding="terminator --borderless --geometry=175x30-0-0 --command=${4}"

existing_keybindins=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings | sed 's/]$/, /')
[ ${#existing_keybindins} -le 10 ] && existing_keybindins=[
new_keybinding="'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${custom_keybinding}/'"
complete_keybinding=${existing_keybindins}${new_keybinding}]

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "${complete_keybinding}"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${custom_keybinding}/ name "${name_keybinding}"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${custom_keybinding}/ binding "${binding_keybinding}"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${custom_keybinding}/ command "${command_keybinding}"
