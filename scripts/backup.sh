#!/usr/bin/bash

# Internal descriptions.

# >>> built-in sets!
set +o histexpand

# >>> variables declaration!
readonly version='3.2.0'
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
label=""
count_max=""

# >>> functions declaration!
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
		if ! dpkg -s "$package" &>/dev/null; then
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
	if grep -qm1 '^!' "$file_dirs"; then
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

set-bkp-dir() {
	log-config
	local relative_path="${1/%\/}"
	[ -w "$location" ] && { old_sudo="$sudo"; unset sudo; }
	$sudo sed -Ei "s~^(path_bkp_dir=\")(.*)\"$~\1$relative_path\"~" \
		"$location"
	sudo="${old_sudo:-$sudo}"
	echo "-> info: changed folder to save backups: \"$relative_path\""
	path_bkp_dir="$relative_path"
}

set-max-count() {
	log-config
	local new_count_max="$1"
	[ -w "$location" ] && { old_sudo="$sudo"; unset sudo; }
	$sudo sed -Ei "s~^(count_max=\")(.*)\"$~\1$new_count_max\"~" \
		"$location"
	sudo="${old_sudo:-$sudo}"
	echo "-> info: changed max backups to save: \"$new_count_max\""
	count_max="$new_count_max"
}

ls-infos() {
	echo "-> label: \"$label\""
	echo "-> folder: \"$path_bkp_dir\""
	echo "-> max: \"$count_max\""
}

decoy() {
	$sudo umount -v "$tmp_mountpoint" 2>&1
	$sudo rmdir -v "$tmp_mountpoint" 2>&1
	echo "-> end: finish script"
	[ "$uid" -eq 0 ] && {
		runuser \
			-l "$user" \
			-c "notify-send \"${script^^}\" 'Finished backup.'"
	} || {
		notify-send "${script^^}" 'Finished backup.'
	}
}

log-config() {
	echo -e "$(separator '#') $(date '+%F %T') $(separator '#')"
}

separator() {
	printf "${1:-*}%.s" `seq 30`
}

# >>> pre statements!
[ ! -d "$(dirname "$file_log")/" ] && mkdir -pv "${file_log%/*}"
exec > >(tee -a "$file_log") 2>&1
#trap failure ERR

privileges
check-needs

if ! options=$(getopt -a -o 'c::f::lp:m::srvh' -n "$script" -- "$@"); then
	exit 1
fi
eval "set -- $options"
while :; do
	option="$1"
	argument="$2"
	case "$option" in
		-c) setup "$argument"; exit;;
		-f) set-bkp-dir "$argument"; exit;;
		-l) ls-infos; exit;;
		-p) opts="$argument"; shift 2;;
		-m) set-max-count "$argument"; exit;;
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
if ! output="$($sudo mount -vL "$label" "$tmp_mountpoint/" 2>&1)"; then
	echo "-> error: can't mount device"
	echo "-> output: $output"
	exit 1
fi
mountpoint="$(findmnt -ro TARGET -S "LABEL=$label" | tail -1)"
[ -z "$mountpoint" ] && {
	echo "-> error: device not mounted"
	exit 1
}
path_base="$mountpoint${path_bkp_dir:+/$path_bkp_dir}"
path_final="$path_base/$suffix"
mkdir -pv "$path_base/" 2>&1
if [ "$count_max" ]; then
	ls -1t "$path_base/$(hostname)-"*.zip \
	| sed -n "$count_max,\$p" \
	| xargs -I '{}' rm -fv '{}' 2>&1
fi
if ! output="$(/usr/bin/time -f '-> time: real %E' -ao "$file_log" -- zip -9ryq $opts "$path_final" -@ < <(grep -v '^!' "$file_dirs") 2>&1)"; then
	echo '-> error: backup process failed'
	echo "-> output: $output"
else
	echo "-> size: $suffix -> $(du -sh "$path_final" | cut -d$'\t' -f1)"
fi
