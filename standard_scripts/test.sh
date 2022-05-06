#!/bin/bash

# tmp_find_path=/tmp/output_find.tmp
# f_time=1

# find / \( -path /proc -prune -o -path /sys -prune \) -o -name "*${1}*" >${tmp_find_path} 2>&- &
# while (ps ${!} >/dev/null); do sleep 1; echo -ne "\rtime: ${f_time}s"; let ++f_time; done; echo
# less ${tmp_find_path}

# custom_keybinding=${1}
# name_keybinding=${2}
# binding_keybinding=${3}
# command_keybinding="terminator --borderless --geometry=175x30-0-0 --command=${4}"

# existing_keybindins=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings | sed 's/]$/, /')
# [ ${#existing_keybindins} -le 10 ] && existing_keybindins=[
# new_keybinding="'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${custom_keybinding}/'"
# complete_keybinding=${existing_keybindins}${new_keybinding}]

# gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "${complete_keybinding}"
# gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${custom_keybinding}/ name "${name_keybinding}"
# gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${custom_keybinding}/ binding "${binding_keybinding}"
# gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${custom_keybinding}/ command "${command_keybinding}"

# [ $(acpi -b | cut -d ',' -f '2' | sed 's/ \|%//g') -ge 96 ] && sudo systemctl suspend

# echo -e "\r\
# 	\r# ********** Declaração de Funções **********\n\
# 	\r# ********** Declaração de Variáveis **********\n\
# 	\r# ********** Início do Programa **********\
# " | xclip -selection clipboard

package=${1}
dependencies=$(mktemp /tmp/apt_dependencies_${package}_XXXXXXXXXX.tmp)
rdependencies=$(mktemp /tmp/apt_rdependencies_${package}_XXXXXXXXXX.tmp)
file=${dependencies}
for option in depends rdepends; do
	apt-cache ${option}\
		--recurse\
		--no-recommends\
		--no-suggests\
		--no-conflicts\
		--no-breaks\
		--no-replaces\
		--no-enhances\
		${package} | sed 's/^ \|^<\|.*Depends: \|>$//g' | sed 's/^<\|^ *//g' | sed '/:i386$/d' > ${file}
	atual_line=1
	while :; do
		total_lines=$(wc -l ${file} | cut -d ' ' -f 1)
		if [ ! ${atual_line} -ge ${total_lines} ]; then
			content_line=$(sed -n "${atual_line}p" ${file})
			next_line=$((${atual_line}+1))
			for ((index=${next_line}; index<=${total_lines}; ++index)); do
				next_content_line=$(sed -n "${index}p" ${file})
				[ "${content_line}" = "${next_content_line}" ] && sed -i "${index}d" ${file}
			done
		else
			exit
		fi
		let ++atual_line
	done
	file="${rdependencies}"
done