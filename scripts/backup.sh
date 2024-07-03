#!/usr/bin/bash

# Internal descriptions.

# >>> built-in sets!
set +o histexpand

# >>> variables declaration!
readonly version='3.0.0'
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
	-f<path/foler>
		Relative path thats store the backups inside the device.
	-l
		List the folder thats store the backups.
	-p<zip-options>
		Can pass own zip options to run with.
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
	label="${1:-$label}"
	: ${label:=BACKUP}
	echo '-> info: scanning dirs file' | tee -a "$file_log"
	[ ! -s "$file_dirs" ] && {
		echo '-> error: no such dirs file or has zero size' \
		| tee -a "$file_log"
		exit 1
	}
	echo '-> info: checking folders to backup' | tee -a "$file_log"
	while read -r folder; do
		clean_path="${folder#!}"
		if [ ! -e "$(readlink -e "$clean_path")" ]; then
			echo "-> warn: \"$clean_path\" not exists" \
			| tee -a "$file_log"
			[[ ! "$folder" =~ ^! ]] \
				&& sed -i "s~^$folder$~\!&~g" "$file_dirs"
		else
			[[ "$folder" =~ ^! ]] \
				&& sed -i "s~^$folder$~$clean_path~g" \
					"$file_dirs"
		fi
	done < "$file_dirs"
	if grep -qm1 '^!' "$file_dirs"; then
		echo '-> info: unexistent paths are ignoreds' \
		| tee -a "$file_log"
	fi
	[ -w "$location" ] \
		&& ${sudo:+} sed -Ei "s~^(label=\")(.*)\"$~\1$label\"~" \
			"$location" \
		|| $sudo sed -Ei "s~^(label=\")(.*)\"$~\1$label\"~" "$location"
	echo '-> info: setting udev rules' | tee -a "$file_log"
	echo "ACTION==\"add\", SUBSYSTEM==\"block\", ENV{ID_FS_LABEL}==\"$label\", RUN+=\"$location\"" \
	| $sudo tee "$file_rules" >/dev/null \
	|| {
		echo "-> error: can't set udev rules" | tee -a "$file_log"
		exit 1
	}
	echo '-> info: all done' | tee -a "$file_log"
}

set-bkp-dir() {
	local relative_path="$1"
	[ -w "$location" ] && { old_sudo="$sudo"; unset sudo; }
	$sudo sed -Ei "s~^(path_bkp_dir=\")(.*)\"$~\1$relative_path\"~" \
		"$location"
	sudo="${old_sudo:-$sudo}"
	path_bkp_dir="$relative_path"
}

ls-bkp-dir() { echo "-> folder: \"$path_bkp_dir\""; }

decoy() {
	$sudo umount -v "$tmp_mountpoint" 2>&1 | tee -a "$file_log"
	$sudo rmdir -v "$tmp_mountpoint" 2>&1 | tee -a "$file_log"
	echo "-> end: finish script" | tee -a "$file_log"
}

# >>> pre statements!
privileges
check-needs

[ ! -d "$(dirname "$file_log")" ] && mkdir -pv "${file_log%/*}"
echo >> "$file_log"
echo -e "~\t~\t~\t $(date '+%F %T') \t~\t~\t~" | tee -a "$file_log"

if ! options=$(getopt -a -o 'c::f:lp:srvh' -n "$script" -- "$@"); then
	exit 1
fi
eval "set -- $options"
while :; do
	option="$1"
	argument="$2"
	case "$option" in
		-c) setup "$argument"; shift 2;;
		-f) set-bkp-dir "$argument"; shift 2;;
		-l) ls-bkp-dir; exit 0;;
		-p) opts="$argument"; shift 2;;
		-s) privileges true false; shift;;
		-r) privileges false true; shift;;
		-v) echo "$version"; exit 0;;
		-h) usage; exit 1;;
		--) shift; break;;
		*) shift 2; break;;
	esac
done

# ***** PROGRAM START *****
# add remove old backups
trap decoy SIGTSTP EXIT
suffix="$(hostname)-$(date '+%F_%T').zip"
tmp_mountpoint="$($sudo mktemp -d "/mnt/$script-XXXXXXX")"
: ${path_bkp_dir:+$path_bkp_dir/}
if ! output="$($sudo mount -vL "$label" "$tmp_mountpoint" 2>&1)"; then
	[[ "$output" =~ can\'t\ find ]] && {
		echo '-> error: device is not plugged' | tee -a "$file_log"
	} || {
		echo "-> error: can't mount device" | tee -a "$file_log"
		echo "-> output: $output" | tee -a "$file_log"
	}
	exit 1
fi
mountpoint="$(findmnt -ro TARGET -S "LABEL=$label" | tail -1)"
path_final="${mountpoint:?device not mounted}/$path_bkp_dir$suffix"
if ! output="$(/usr/bin/time -f '-> time: real %E' -ao "$file_log" -- zip -9ryq $opts "$path_final" -@ < <(grep -v '^!' "$file_dirs") 2>&1)"; then
	echo '-> error: backup process failed' | tee -a "$file_log"
	echo "-> output: $output" | tee -a "$file_log"
else
	echo "-> size: $suffix -> $(du -sh "$path_final" | cut -d$'\t' -f1)" \
		| tee -a "$file_log"
fi
