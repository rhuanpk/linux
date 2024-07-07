#!/usr/bin/bash

# Internal descriptions.

# >>> built-in sets!
set -Eo pipefail +o histexpand

# >>> variables declaration!
readonly version='3.5.2'
readonly location="$(realpath -s "$0")"
readonly script="$(basename "$0")"
readonly uid="${UID:-$(id -u)}"
readonly user="$(id -un "${uid/#0/1000}")"
readonly home="/home/$user"

path_bkp_dir=""
relative_log=".local/share/$script/backups.log"
relative_dirs=".config/$script/backups.dirs"
file_log="$home/$relative_log"
file_dirs="$home/$relative_dirs"
file_rules='/etc/udev/rules.d/backups.rules'
is_auto="true"
label=""
count_max=""

# >>> functions declaration!
failure() {
	notify "Failure: some error occurred on line $BASH_LINENO!" critical
	return 1
}

usage() {
cat << EOF
$script v$version

DESCRIPTION
	Backup script thats are trigged when some device are "plugged".

	Before run the $script first and each time that it changed the place,
	run:
		$script -c

	Put the absolute paths of the folders thats is desired to backup inside
	the "~/$relative_dirs" file, one per line e.g.:
		/path/to/folder/some
		/path/to/folder/any
		/path/to/folder/white space

	The log file is in "~/$relative_log".

USAGE
	$script [<options>]

OPTIONS
	-c[<label>]
		Configure the udev rules. Can pass the device label, default is
		"BACKUP".
	-f[<path/foler>]
		Relative path thats store the backups inside the device.
	-l
		List the folder thats store the backups.
	-p<zip-options>
		Can pass own zip options to run with.
	-m[<number>]
		Set a max integer number to retain backups.
	-a
		Toggle into automatic or not the backup when the device is
		plugged.
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

setup() {
	log-config
	label="${1:-$label}"
	: ${label:=BACKUP}
	echo '-> info: scanning dirs file'
	[ ! -s "$file_dirs" ] && {
		echo '-> error: no such dirs file or has zero size'
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
				&& sed -i "s~^$folder$~$clean_path~g" \
					"$file_dirs"
		fi
	done < "$file_dirs"
	if (grep -qm1 '^!' "$file_dirs" || failure); then
		echo '-> info: unexistent paths are ignoreds'
	fi
	[ -w "$location" ] \
		&& ${sudo:+} sed -Ei "s~^(label=\")(.*)\"$~\1$label\"~" \
			"$location" \
		|| $sudo sed -Ei "s~^(label=\")(.*)\"$~\1$label\"~" "$location"
	echo '-> info: setting udev rules'
	echo "ACTION==\"add\", SUBSYSTEM==\"block\", ENV{ID_FS_LABEL}==\"$label\", TAG+=\"systemd\", ENV{SYSTEMD_WANTS}=\"backups.service\"" \
	| $sudo tee "$file_rules" >/dev/null \
	|| {
		echo "-> error: can't set udev rules"
		exit 1
	}
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
		-> label: "$label"
		-> folder: "$path_bkp_dir"
		-> max: "$count_max"
		-> automatic: "$is_auto"
	EOF
}

decoy() {
	$sudo umount -v "$tmp_mountpoint"
	$sudo rmdir -v "$tmp_mountpoint"
	echo "-> end: finish script"
	notify 'Finished backup.'
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

# >>> pre statements!
[ ! -d "$(dirname "$file_log")/" ] && mkdir -pv "${file_log%/*}"
exec 3>&1 > >(tee -a "$file_log") 2>&1
trap failure ERR

privileges
check-needs

if ! options=$(getopt -a -o 'c::f::lp:m::asrvh' -n "$script" -- "$@"); then
	exit 1
fi
eval "set -- $options"
while :; do
	option="$1"
	argument="$2"
	case "$option" in
		-c) setup "$argument"; exit;;
		-l) ls-infos; exit;;
		-p) opts="$argument"; shift 2;;
		-f)
			set-var \
				'path_bkp_dir' \
				"${argument/%\/}" \
				'changed folder to save backups'
			exit
		;;
		-m)
			set-var \
				'count_max' \
				"$argument" \
				'changed max backups to save'
			exit
		;;
		-a)
			if "$is_auto"; then
				argument='false'
			else
				argument='true'
			fi
			set-var \
				'is_auto' \
				"$argument" \
				'changed automatic backup when stick plugged'
			if "${is_auto:?is auto must be set}"; then
				[ -f "$file_rules.off" ] && $sudo mv -v "$file_rules"{.off,}
			else
				[ -f "$file_rules" ] && $sudo mv -v "$file_rules"{,.off}
			fi
			exit
		;;
		-s) privileges true false; shift;;
		-r) privileges false true; shift;;
		-v) echo "$version"; exit 0;;
		-h) usage; exit 1;;
		--) shift; break;;
		*) shift 2; break;;
	esac
done

trap decoy EXIT

# ***** PROGRAM START *****
echo -e "$(separator '~') $(date '+%F %T') $(separator '~')"
suffix="$(hostname)-$(date '+%F_%T').zip"
tmp_mountpoint="$($sudo mktemp -d "/mnt/$script-XXXXXXX")"
if ! ($sudo mount -vL "$label" "$tmp_mountpoint/" || failure); then
	echo "-> error: can't mount device"
	exit 1
fi
mountpoint="$(findmnt -ro TARGET -S "LABEL=$label" | tail -1)"
[ -z "$mountpoint" ] && {
	echo "-> error: device not mounted"
	exit 1
}
path_base="$mountpoint${path_bkp_dir:+/$path_bkp_dir}"
path_final="$path_base/$suffix"
mkdir -pv "$path_base/"
if [ "$count_max" ]; then
	ls -1t "$path_base/$(hostname)-"*.zip \
	| sed -n "$count_max,\$p" \
	| xargs -I '{}' rm -fv '{}'
fi
if ! (/usr/bin/time -f '-> time: real %E' -ao "$file_log" -- zip -9ryq $opts "$path_final" -@ < <(grep -v '^!' "$file_dirs") || failure ); then
	echo '-> error: backup process failed'
else
	echo "-> size: $suffix -> $(du -sh "$path_final" | cut -d$'\t' -f1)"
fi
