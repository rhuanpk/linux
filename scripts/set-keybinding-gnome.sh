#!/usr/bin/bash

# Set a new binding for gnome environments.

# >>> variables declaration!
readonly version='2.1.0'
readonly script="`basename "$0"`"

CUSTOM_KEYBINDING="${1:?need the name binding}"
NAME_KEYBINDING="${2:?need the description binding}"
BINDING_KEYBINDING="${3:?need the keyboard binding}"
COMMAND_KEYBINDING="${4:?need the command to execute}"
MEDIAKEYS_GSETTINGS='org.gnome.settings-daemon.plugins.media-keys'
CUSTOMKEYBINDING_GSETTINGS='custom-keybinding'
EXISTING_KEYBINDINS="`gsettings get $MEDIAKEYS_GSETTINGS ${CUSTOMKEYBINDING_GSETTINGS}s | sed 's/]$/, /'`"
PATH_KEYBINDING="/org/gnome/settings-daemon/plugins/media-keys/${CUSTOMKEYBINDING_GSETTINGS}s"
NEW_KEYBINDING="'$PATH_KEYBINDING/${CUSTOM_KEYBINDING}/'"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Set a new binding for gnome environments passing the following params:
	1. Name of binding;
	2. Description of binding;
	3. Binding;
	4. Command which call the binding.

Usage:
	$script volume0 'Volume Control' '<Alt>v' volume-contro

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
[ "${#EXISTING_KEYBINDINS}" -le '10' ] && EXISTING_KEYBINDINS='['
COMPLETE_KEYBINDING="${EXISTING_KEYBINDINS}${NEW_KEYBINDING}]"
gsettings set "$MEDIAKEYS_GSETTINGS" "${CUSTOMKEYBINDING_GSETTINGS}s" "$COMPLETE_KEYBINDING"
gsettings set "$MEDIAKEYS_GSETTINGS.$CUSTOMKEYBINDING_GSETTINGS:$PATH_KEYBINDING/$CUSTOM_KEYBINDING/" 'name' "$NAME_KEYBINDING"
gsettings set "$MEDIAKEYS_GSETTINGS.$CUSTOMKEYBINDING_GSETTINGS:$PATH_KEYBINDING/$CUSTOM_KEYBINDING/" 'binding' "$BINDING_KEYBINDING"
gsettings set "$MEDIAKEYS_GSETTINGS.$CUSTOMKEYBINDING_GSETTINGS:$PATH_KEYBINDING/$CUSTOM_KEYBINDING/" 'command' "$COMMAND_KEYBINDING"
