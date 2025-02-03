#!/usr/bin/bash

# >>> built-in sets
set -Eo pipefail +o histexpand

# >>> variables declaration
readonly version='3.8.4'
readonly location="$(realpath -s "$0")"
readonly script="$(basename "$0")"
readonly uid="${UID:-$(id -u)}"
readonly user="$(id -un "${uid/#0/1000}")"
readonly home="/home/$user"

type_bkp_dev="device"
type_bkp_local="local"
type_bkp=""
path_bkp_dev=""
path_bkp_local="/tmp"
relative_log=".local/share/$script/backup.log"
relative_pid=".local/etc/$script/backup.pid"
relative_dirs=".config/$script/backup.dirs"
file_log="$home/$relative_log"
file_pid="$home/$relative_pid"
file_dirs="$home/$relative_dirs"
file_rules="/etc/udev/rules.d/backup.rules"
udev_label=""
count_max_bkps=""
flag_auto_udev="true"
flag_auto_rm="false"

# >>> functions declaration
failure() {
	notify "Failure: some error occurred on line $BASH_LINENO!" critical
	echo '-> error: backup process failure'
	return 1
}

decoy() {
	remove-zip-tmps
	[[ "$type_bkp" = "$type_bkp_dev" && "$tmp_mountpoint" ]] && {
		$sudo umount -v "$tmp_mountpoint"
		$sudo rmdir -v "$tmp_mountpoint"
	}
	echo "-> end: finish script"
	notify 'Backup finished.'
}

usage() {
cat << EOF
$script v$version

DESCRIPTION
	Backup script that can be configured to be triggered when a removable
	device is plugged.

	Before run the $script first time and each time that it changed the
	PLACE (the script itself), run:
		$script -c

	Put the absolute paths of the folders thats is desired to backup inside
	the "~/$relative_dirs" file, one per line e.g.:
		/path/to/folder/stuff
		/path/to/folder/foo bar

	The log file is in "~/$relative_log".
	The pid file is in "~/$relative_pid".

USAGE
	$script [-p] [-t] [<options>]

OPTIONS
	-c[<label>]
		Configure the UDEV RULES. Can pass the device label (default is
		"BACKUP").
	-t<type>
		Override once the atual backup type (must be "$type_bkp_dev"
		or "$type_bkp_local").
	-f[<path>]
		Relative path inside the deviec that store the backups.
	-m[<integer>]
		Set the maximum number of versions.
	-p<zip-options>
		Can pass own ZIP OPTIONS to run with.
	-l<path>
		Absolute path for local backup (standard is "/tmp").
	-a
		Toggle the automatic backup when the device is plugged.
	-b
		Configure the backup type.
	-i
		List the scrip configs.
	-d
		Dry-run the zip and prints the final MiB size.
	-k
		Kill the backup running in background.
	-x
		Toggle the automatic removal zip temporary files if exists.
	-s
		Forces keep sudo.
	-r
		Forces unset sudo.
	-v
		Print version.
	-h
		Print this help.

OBSERVATIONS
	- Once the script runs, if any path on backups.dirs do not exists, it
	will be marked with one "!" in begin of line.

	- The absolute path in \`-l' option is some path in the filesystem,
	like a absolute path in a already mounted device too.

	- When the \`-k' option is used and the zip process is killed, it will
	most likely leave behind its temporary buffer files that it used to
	perform compression. If the \`-x' flag is true, then in the script
	decoy, the temporary files from the zip command resulting from the use
	of the \`-k' flag will be removed (using a \`[sudo] rm -fv' command).
	Is this safe?

	- Always uses \`-k' to cancel the backup.
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

check-needs() {
	privileges
	local packages=('time')
	for package in "${packages[@]}"; do
		if ! (dpkg -s "$package" &>/dev/null || failure); then
			echo -en "$script: ask: needed \"$package\", "
			read -rp "install? [Y/n] "
			[ -z "$REPLY" ] || [ 'y' = "${REPLY,,}" ] && {
				$sudo apt install -y "$package"
			}
		fi
	done
}

local-configure() {
	echo -e "$(separator '#') $(date '+%F %T') $(separator '#')"
	echo -e "-> ask: choose the default backup type\n--> 1: $type_bkp_dev\n--> 2: $type_bkp_local"
	read -ep '-> answer: '
	case "$REPLY" in
		1) set-var 'type_bkp' "$type_bkp_dev" 'configure the backup type';;
		2) set-var 'type_bkp' "$type_bkp_local" 'configure the backup type';;
		*) echo '-> error: invalid option'; exit;;
	esac
}

setup() {
	log-config
	local label="${1:-$udev_label}"
	: ${label:=BACKUP}
	echo '-> info: scanning dirs file'
	[ ! -s "$file_dirs" ] && {
		echo '-> error: no such dirs file or has nothing'
		exit 1
	}
	echo '-> info: checking folders to backup'
	# folder's here are files or directories
	while read -r folder; do
		clean_path="${folder#!}"
		if [ ! -e "$(readlink -e "$clean_path")" ]; then
			echo "-> warn: \"$clean_path\" not exists"
			[[ ! "$folder" =~ ^! ]] \
				&& sed -i "s~^$folder$~\!&~g" "$file_dirs"
		else
			[[ "$folder" =~ ^! ]] \
				&& sed -i "s~^$folder$~$clean_path~g" "$file_dirs"
		fi
	done < "$file_dirs"
	if (grep -qm1 '^!' "$file_dirs" || { [ "$?" -eq 2 ] && failure; }); then
		echo '-> info: unexistent paths are ignoreds'
	fi
	[ -w "$location" ] \
		&& sed -Ei "s~^(udev_label=\").*\"$~\1$label\"~" "$location" \
		|| $sudo sed -Ei "s~^(udev_label=\").*\"$~\1$label\"~" "$location"
	echo '-> info: setting udev rules'
	echo "ACTION==\"add\", SUBSYSTEM==\"block\", ENV{ID_FS_LABEL}==\"$label\", TAG+=\"systemd\", ENV{SYSTEMD_WANTS}=\"backups.service\"" \
	| $sudo tee "$file_rules" >/dev/null \
		|| { echo "-> error: can't set udev rules"; exit 1; }
	on-off-rules "$flag_auto_udev"
	echo '-> info: setting systemd unit'
	cat <<- EOF | $sudo tee /etc/systemd/system/backups.service >/dev/null
		[Unit]
		Description=Backup Script
		After=local-fs.target

		[Service]
		Type=exec
		ExecStart=$location

		[Install]
		WantedBy=multi-user.target
	EOF
	echo '-> info: all done'
}

set-var() {
	log-config
	local var_name="$1"
	local new_value="$2"
	local message="$3"
	[ -w "$location" ] && { old_sudo="$sudo"; unset sudo; }
	$sudo sed -Ei "s~^($var_name=\").*\"$~\1$new_value\"~" "$location"
	sudo="${old_sudo:-$sudo}"
	echo "-> info: $message: \"$new_value\""
	eval $var_name="$new_value"
}

ls-infos() {
	cat <<- EOF >&3
		$(separator '"') ${script^^} $(separator '"')
		-> label: "$udev_label"
		-> folder: "$path_bkp_dev"
		-> max: "$count_max_bkps"
		-> automatic: "$flag_auto_udev"
		-> local: "$path_bkp_local"
		-> type: "$type_bkp"
		-> removes: "$flag_auto_rm"
	EOF
}

log-config() {
	echo -e "$(separator '#') $(date '+%F %T') $(separator '#')"
}

separator() {
	printf "${1:-*}%.s" `seq 30`
}

notify() {
	local message="$1"
	local urgency="${2:-normal}"
	[ "$uid" -eq 0 ] && {
		runuser \
			-l "$user" \
			-c "notify-send -u $urgency '${script^^}' ${message@Q}"
	} || {
		notify-send -u $urgency "${script^^}" "$message"
	}
}

check-zip-size() {
	calc () {
		value="${1:?need a value to calc}"
		expo="${2:?need a expo to calc}"
		expr="$(echo "$value" | sed "s/<value>/$(cat)/" <<< 'scale=2; <value>/1024^<expo>')"
		expr="$(echo "$expo" | sed "s/<expo>/$(cat)/" <<< "$expr")"
		echo "$expr" | bc
	}
	echo -e "$(separator '!') $(date '+%F %T') $(separator '!')"
	while :; do
		for symbol in \| / - \\ \| / -; do
			echo -en "\rRunning dry-run $symbol " >&3
			sleep .1
		done
	done &
	local prefix='MiB'
	local start_time="$(date '+%s')"
	local bytes="$(zip -9rq - $(grep -v '^!' "$file_dirs" | tr '\n' ' ') | wc -c)"
	local end_time="$(date '+%s')"
	local size="$(calc "$bytes" 2)"
	(( $(bc -l <<< "$size > 1024") )) && { size="$(calc "$bytes" 3)"; prefix='GiB'; }
	kill "$!"
	echo -e "-> time: $(date -ud "@$((end_time - start_time))" '+%T')"
	echo -e "-> size: $size $prefix"
}

on-off-rules() {
	is_auto="${1:?is auto must be set}"
	if "$is_auto"; then
		if test -f "$file_rules.off"; then $sudo mv -v "$file_rules"{.off,}; fi
	else
		if test -f "$file_rules"; then $sudo mv -v "$file_rules"{,.off}; fi
	fi
}

toggle-automatic() {
	local argument='true'
	if "$flag_auto_udev"; then
		argument='false'
	fi
	set-var 'flag_auto_udev' "$argument" 'changed automatic backup when device plugged'
	on-off-rules "$flag_auto_udev"
}

toggle-remove() {
	local argument='true'
	if "$flag_auto_rm"; then
		argument='false'
	fi
	set-var 'flag_auto_rm' "$argument" 'changed automatic remove zip tmp files'
}

kill-running() {
	log-error() {
		echo '-> error: pid file not set or backup not running to kill'
	}
	[ -s "$file_pid" ] && {
		[ "$uid" -eq 0 ] && unset sudo || sudo='sudo'
		$sudo kill -9 "$(cat "$file_pid")" || log-error
	} || log-error
}

remove-zip-tmps() {
	if "$flag_auto_rm" && [ "$path_base" ]; then
		exec 9< <(file "$path_base"/*)
		while read -u9; do
			local file="$(cut -d: -f1 <<< "$REPLY")"
			local message="$(cut -d: -f 2- <<< "$REPLY")"
			[[ "$message" =~ ^[[:blank:]]*Zip\ archive\ data ]] && {
				#read -ep "-> ask: remove residual zip file '$file'? (Y/n) "
				#[ -z "$REPLY" -o "${REPLY,,}" = 'y' ] && $sudo rm -fv "$file"
				$sudo rm -fv "$file"
			}
		done; exec 9<&-
	else
		return 0
	fi
}

set-path-base() {
	if [ "$type_bkp" = "$type_bkp_dev" ]; then
		path_base="$mountpoint${path_bkp_dev:+/$path_bkp_dev}"
	elif [ "$type_bkp" = "$type_bkp_local" ]; then
		path_base="$path_bkp_local"
	fi
}

# >>> pre statements
for folder in "$file_log" "$file_pid"; do
	[ ! -d "$(dirname "$folder")/" ] && mkdir -pv "${folder%/*}"
done
exec 3>&1 > >(tee -a "$file_log") 2>&1
trap failure ERR

privileges
check-needs

if ! options=$(getopt -a -o 'c::t:f::m::p:l:abidkxsrvh' -n "$script" -- "$@"); then
	exit 1
fi
eval "set -- $options"
while :; do
	option="$1"
	argument="$2"
	case "$option" in
		-c) setup "$argument"; exit;;
		-t) type_bkp="$argument"; shift 2;;
		-f) set-var 'path_bkp_dev' "${argument/%\/}" 'changed folder to save device backups'; exit;;
		-m) set-var 'count_max_bkps' "$argument" 'changed max backups to save'; exit;;
		-p) opts="$argument"; shift 2;;
		-l) set-var 'path_bkp_local' "${argument/%\/}" 'changed folder to save local backups'; exit;;
		-a) toggle-automatic; exit;;
		-b) local-configure; exit;;
		-i) ls-infos; exit;;
		-d) check-zip-size; exit;;
		-k) kill-running; exit;;
		-x) toggle-remove; exit;;
		-s) privileges true false; shift;;
		-r) privileges false true; shift;;
		-v) echo "$version"; exit 0;;
		-h) usage >&3; exit 1;;
		--) shift; break;;
		*) shift 2; break;;
	esac
done

trap decoy EXIT

# ***** PROGRAM START *****
# To know the diff between new files/folders in a dir, run:
# 	find /path/to/know -maxdepth 1 > /tmp/folders.txt \
# 	&& cat ~/.config/backup/backups.dirs \
# 		| grep --color=never ^/path/to/know >> /tmp/folders.txt \
# 	&& sort /tmp/folders.txt \
# 		| uniq -u > /tmp/not-folders.txt
# Edit the "/tmp/not-folders.txt" then test with to se if every seems ok:
# 	zip -9ryv /tmp/test.zip -@ < /tmp/not-folders.txt
echo -e "$(separator '~') $(date '+%F %T') $(separator '~')"
[ -z "$type_bkp" ] && {
	echo '-> error: the backup type (-b) must be set'
	exit 1
}
[ "$type_bkp" != "$type_bkp_dev" -a "$type_bkp" != "$type_bkp_local" ] && {
	echo "-> error: the backup type must be \"$type_bkp_dev\" or \"$type_bkp_local\""
	exit 1
}
if [ "$type_bkp" = "$type_bkp_dev" ]; then
	[ -z "$udev_label" ] && {
		echo '-> error: the udev label (-c) must be set'
		exit 1
	}
	tmp_mountpoint="$($sudo mktemp -d "/mnt/$script-XXXXXXX")"
	if ! ($sudo mount -vL "$udev_label" "$tmp_mountpoint/" || failure); then
		echo "-> error: can't mount device"
		exit 1
	fi
	mountpoint="$(findmnt -ro TARGET -S "LABEL=$udev_label" | tail -1)"
	[ -z "$mountpoint" ] && {
		echo "-> error: device not mounted"
		exit 1
	}
fi
set-path-base
suffix="$(hostname)-$(date '+%F_%T').zip"
path_final="$path_base/$suffix"
mkdir -pv "$path_base/"
if [ "$count_max_bkps" ]; then
	if output="$(ls -1t "$path_base/$(hostname)-"*.zip)"; then
		sed -n "$count_max_bkps,\$p" <<< "$output" \
		| xargs -I '{}' rm -fv '{}'
	fi
fi
notify 'Backup started.'
start_time="$(date '+%s')"
zip -9ryq $opts "$path_final" -@ < <(grep -v '^!' "$file_dirs") & echo "$!" > "$file_pid"
while kill -0 "$(cat "$file_pid")" 2>&-; do
	sleep 1
done 2>&-
end_time="$(date '+%s')"
echo -e "-> time: $(date -ud "@$((end_time - start_time))" '+%T')"
echo "-> size: $suffix: $(du -sh "$path_final" | cut -d$'\t' -f1 || echo 'n/a')"
