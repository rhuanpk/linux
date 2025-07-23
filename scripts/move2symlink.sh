#!/usr/bin/bash

# >>> variables declaration
readonly version='2.1.0'
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
	Create symlinks of scripts in the folder.
	By default from \$PATH_SCRIPTS to ${home_bin@Q}.

USAGE
	$script [<options>]

OPTIONS
	-b
		Saves the symlinks in ${root_bin@Q} instead ${home_bin@Q}.
	-d [<path>]
		Saves the symlinks in the specified folder, if no argument
		is provided, \`pwd' is the default.
	-p [<path>]
		Instead get the path of folder from \$PATH_SCRIPTS, get it
		from \`pwd' or specified path.
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

while getopts ':bd:p:srvh' option; do
	case "$option" in
		b)
			local_bin="$root_bin"
			privileges
		;;
		d) local_bin="${OPTARG%/}";;
		p) path="${OPTARG%/}";;
		:) setargs "$OPTARG";;
		s) privileges true false;;
		r) privileges false true;;
		v) echo "$version"; exit 0;;
		h) usage; exit 1;;
		*) exit 2;;
	esac
done
shift $(("$OPTIND"-1))

: ${path:?need a path to move scripts}

# ***** PROGRAM START *****
excludes=(
	'backup.sh'
	'volume-encryption-utility.sh'
)

for file in "$path"/*.sh; do
	name="$(basename "$file")"
	[[ "${excludes[*]}" =~ $name ]] && continue
	$sudo ln -sfv "$file" "$local_bin/${name%.sh}"
done
