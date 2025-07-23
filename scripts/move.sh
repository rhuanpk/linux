#!/usr/bin/bash

# >>> variables declaration
readonly version='2.3.0'
readonly script="$(basename "$0")"
readonly uid="${UID:-$(id -u)}"

readonly root_bin='/usr/local/bin'
readonly home_bin="$HOME/.local/bin/"
local_bin="$home_bin"

# >>> functions declaration
usage() {
cat << EOF
$script v$version

DESCRIPTION
	Copy the scripts from \$PATH_SCRIPTS to ${home_bin@Q}.

USAGE
	$script [<options>]

OPTIONS
	-b
		Saves in ${root_bin@Q} instead ${home_bin@Q}.
	-l
		Make symlinks instead copies.
	-p [<path>]
		Saves from specified folder (default is \`pwd').
	-d [<path>]
		Saves to specified folder (default is \`pwd').
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
	get_pm_cmd() {
		which -s apk && { echo 'apk add'; return; }
		which -s apt && { echo 'apt install'; return; }
		which -s dnf && { echo 'dnf install'; return; }
		which -s yum && { echo 'yum install'; return; }
		which -s pkg && { echo 'pkg install'; return; }
		which -s pacman && { echo 'pacman -S'; return; }
		which -s emerge && { echo 'emerge -av'; return; }
		which -s zypper && { echo 'zypper install'; return; }
		which -s portage && { echo 'portage install'; return; }
	}
	privileges
	local packages=('curl')
	for package in "${packages[@]}"; do
		if ! dpkg -s "$package" &>/dev/null; then
			echo -ne "$script: ask: needed \"$package\", "
			read -rp  "install? [Y/n] "
			[ -z "$REPLY" ] || [ 'y' = "${REPLY,,}" ] && {
				$sudo `get_pm_cmd` "$package" || exit $?
			}
		fi
	done
}

setpath() {
	local setpath_url='https://raw.githubusercontent.com/rhuanpk/linux/refs/heads/main/scripts/.private/setpath.sh'
	path="${PATH_SCRIPTS:-$(curl -fsL "$setpath_url" | bash -s -- -p scripts)}"
}

setargs() {
	local arg="${1:-need a arg to set}"
	[ "$arg" = 'd' ] && local_bin="$(pwd)"
	[ "$arg" = 'p' ] && path="$(pwd)"
}

# >>> pre statements
check-needs
setpath

unset sudo

while getopts ':blp:d:srvh' option; do
	case "$option" in
		b)
			local_bin="$root_bin"
			privileges
		;;
		l) flag_symlink=true;;
		p) path="${OPTARG%/}";;
		d) local_bin="${OPTARG%/}";;
		:) setargs "$OPTARG";;
		s) privileges true false;;
		r) privileges false true;;
		v) echo "$version"; exit 0;;
		h) usage; exit 1;;
		*) exit 2;;
	esac
done
shift $(("$OPTIND"-1))

: ${path:=$(pwd)}

# ***** PROGRAM START *****
excludes=(
	'backup.sh'
	'volume-encryption.sh'
)

for src in "$path"/*.sh; do
	cmd='cp -fv'
	name="$(basename "$src")"
	dst="$local_bin/${name%.sh}"
	[[ "${excludes[*]}" =~ $name ]] && continue
	if "${flag_symlink:-false}"; then
		cmd='ln -sfv'
	fi
	[ -L "$dst" ] && rm -fv "$dst"
	eval "$sudo $cmd '$src' '$dst'"
done
