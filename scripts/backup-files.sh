#!/usr/bin/bash

# Make a backup of some important files.

# >>> built-in setups!
shopt -s extglob

# >>> variables declaration!
readonly version='1.9.0'
readonly script="`basename "$0"`"
readonly uid="${UID:-`id -u`}"
readonly user="`id -un "${uid/#0/1000}"`"
readonly home="/home/$user"

# where data are stored
PATHWAY_BACKUP="$home/Documents/cfb/hosts/`hostname`"
declare -A ARRAY_PATHWAY_BACKUP=(
	['opt']="$PATHWAY_BACKUP/opt"
	['fonts']="$PATHWAY_BACKUP/fonts"
	['iconthemes']="$PATHWAY_BACKUP/icons-themes"
	['terminator']="$PATHWAY_BACKUP/terminator"
	['dpkg']="$PATHWAY_BACKUP/dpkg"
	['neofetch']="$PATHWAY_BACKUP/neofetch"
	['misc']="$PATHWAY_BACKUP/misc"
	['gtk']="$PATHWAY_BACKUP/gtk"
	['localbin']="$PATHWAY_BACKUP/local-bin"
	['history']="$PATHWAY_BACKUP/history"
	['git']="$PATHWAY_BACKUP/git"
	['vim']="$PATHWAY_BACKUP/vim"
	['cron']="$PATHWAY_BACKUP/cron"
	['dunst']="$PATHWAY_BACKUP/dunst"
	['shellrc']="$PATHWAY_BACKUP/shellrc"
	['ssh']="$PATHWAY_BACKUP/ssh"
	['obs-profiles']="$PATHWAY_BACKUP/obs/profiles"
	['obs-scenes']="$PATHWAY_BACKUP/obs/scenes"
	['vscode']="$PATHWAY_BACKUP/vscode"
	['mangohud']="$PATHWAY_BACKUP/mangohud"
)

# place from to get data
PATHWAY_OPT='/opt'
PATHWAY_FONTS="$home/Documents/fonts"
PATHWAY_ICONS="$home/.local/share/icons"
PATHWAY_THEMES="$home/.local/share/themes"
PATHWAY_TERMINATOR="$home/.config/terminator/config"
PATHWAY_TREE="$home/misc"
PATHWAY_GTK="$home/.config/gtk-3.0/settings.ini"
PATHWAY_LOCALBIN="/usr/local/bin"
PATHWAY_HISTORY="$home/.bash_history"
PATHWAY_GIT="$home/.gitconfig"
PATHWAY_VIM="$home/.vimrc"
PATHWAY_DUNST="$home/.config/dunst/dunstrc"
PATHWAY_SHELLRC="$home/.config/shellrc"
PATHWAY_SSH="$home/.ssh/config"
PATHWAY_OBS_PROFILES="$home/.config/obs-studio/basic/profiles"
PATHWAY_OBS_SCENES="$home/.config/obs-studio/basic/scenes"
PATHWAY_VSCODE="$home/.config/Code/User/settings.json"
PATHWAY_MANGOHUD="$home/.config/MangoHud/MangoHud.conf"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Make a backup of some important files.

Usage: $script [<options>]

Options:
	-v: Print version;
	-h: Print this help.
EOF
}

make-date() {
	date '+%y-%m-%d_%H%M%S'
}

cleanup-history() {
	files=("${ARRAY_PATHWAY_BACKUP['history']}"/*)
	for file in ${files[@]: 0:$((${#files[@]}-1))}; do
		find "$file" -mtime +2 -exec rm -f '{}' \;
	done
}

cp-backup() {
	local file_source="$1"
	local folder_backup="${2%/}"
	local old_file="$(ls -1t "$folder_backup"/?(.)* 2>&- | head -1)"
	local new_file="$folder_backup/${file_source##*/}_`make-date`.gz"
	gzip -c9 "$file_source" >"$new_file"
	if cmp -s "$old_file" "$new_file"; then
		rm -f "$new_file"
	fi
}

# >>> pre statements!
while getopts 'vh' OPTION; do
	case "$OPTION" in
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
# create necessary folders
for pathway in "${ARRAY_PATHWAY_BACKUP[@]}"; do
	[ ! -d "$pathway/" ] && mkdir -p "$pathway/"
done

# clean ups
cleanup-history

# commands ls to save
ls -1 "$PATHWAY_OPT" | cat -n | tr -s ' ' >"${ARRAY_PATHWAY_BACKUP['opt']}/optionals.txt"
ls -1 "$PATHWAY_FONTS" | cat -n | tr -s ' ' >"${ARRAY_PATHWAY_BACKUP['fonts']}/fonts.txt"
ls -1 "$PATHWAY_ICONS" | cat -n | tr -s ' ' >"${ARRAY_PATHWAY_BACKUP['iconthemes']}/icons.txt"
ls -1 "$PATHWAY_THEMES" | cat -n | tr -s ' ' >"${ARRAY_PATHWAY_BACKUP['iconthemes']}/themes.txt"
ls -1 "$PATHWAY_LOCALBIN" | cat -n | tr -s ' ' >"${ARRAY_PATHWAY_BACKUP['localbin']}/binaries.txt"

# commands cp to save
cp-backup "$PATHWAY_TERMINATOR" "${ARRAY_PATHWAY_BACKUP['terminator']}"
cp-backup "$PATHWAY_GTK" "${ARRAY_PATHWAY_BACKUP['gtk']}"
cp-backup "$PATHWAY_GIT" "${ARRAY_PATHWAY_BACKUP['git']}"
cp-backup "$PATHWAY_VIM" "${ARRAY_PATHWAY_BACKUP['vim']}"
cp-backup "$PATHWAY_DUNST" "${ARRAY_PATHWAY_BACKUP['dunst']}"
cp-backup "$PATHWAY_SHELLRC" "${ARRAY_PATHWAY_BACKUP['shellrc']}"
cp-backup "$PATHWAY_SSH" "${ARRAY_PATHWAY_BACKUP['ssh']}"
cp-backup "$PATHWAY_VSCODE" "${ARRAY_PATHWAY_BACKUP['vscode']}"
cp-backup "$PATHWAY_MANGOHUD" "${ARRAY_PATHWAY_BACKUP['mangohud']}"
cp -rf "$PATHWAY_OBS_PROFILES/"* "${ARRAY_PATHWAY_BACKUP['obs-profiles']}/"
cp -rf "$PATHWAY_OBS_SCENES/"* "${ARRAY_PATHWAY_BACKUP['obs-scenes']}/"

# others commands to save
tree "$PATHWAY_TREE" >"${ARRAY_PATHWAY_BACKUP['misc']}/tree.txt"
dpkg -l >"${ARRAY_PATHWAY_BACKUP['dpkg']}/list.txt"
neofetch >"${ARRAY_PATHWAY_BACKUP['neofetch']}/infos.txt"
crontab -l >"${ARRAY_PATHWAY_BACKUP['cron']}/crontab.txt"

# complex commands to save
FILE_NAME_HISTORY="${ARRAY_PATHWAY_BACKUP['history']}/bash-history_`make-date`.gz"
gzip -c9 "$PATHWAY_HISTORY" >"$FILE_NAME_HISTORY"
chmod 600 "$FILE_NAME_HISTORY"
