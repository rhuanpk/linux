#!/usr/bin/bash

# >>> variables declaration
readonly version='1.0.0'
readonly script="$(basename "$0")"
readonly uid="${UID:-$(id -u)}"

# >>> functions declaration
usage() {
cat << EOF
$script v$version

DESCRIPTION
	Print or clone all GitHub repositories owned by the owner of Personal Access Token.

	The repositories will be cloned in the current directory.

USAGE
	$script [-c] -t {http|ssh} "<token>"

OPTIONS
	-t {http|ssh}
		Choose the clone type.
	-c
		Clone the repositories instead only print URLs.
	-s
		Force keep the sudo.
	-r
		Force run as root.
	-v
		Print version.
	-h
		Print help.
EOF
}

privileges() {
	local flag_sudo="$1"
	local flag_root="$2"
	: ${uid:?need set uid}
	if "${flag_root:-false}"; then
		((uid != 0)) && {
			echo "$script: error: run as root (!sudo)" >&2
			exit 1
		}
		unset sudo
		return 0
	fi
	if "${flag_sudo:-false}"; then
		sudo='sudo'
		return 0
	fi
	sudo='sudo'
	((uid == 0)) && unset sudo
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
	local packages=('git' 'curl')
	for package in "${packages[@]}"; do
		if ! which -s "$package"; then
			echo -ne "$script: ask: needed \"$package\", "
			read -rp  "install? [Y/n] "
			[ -z "$REPLY" ] || [ 'y' = "${REPLY,,}" ] && {
				$sudo `get_pm_cmd` "$package" || exit $?
			}
		fi
	done
}

set-type() {
	local flag_type="${1:?need a type to set}"
	if [[ "$flag_type" != 'http' && "$flag_type" != 'ssh' ]]; then
		echo "$script: err: wrong clone type" >&2
		return 1
	fi
	clone_type="$flag_type"
}

# >>> pre statements
privileges
check-needs

while getopts 't:csrvh' option; do
	case "$option" in
		t) set-type "$OPTARG" || exit;;
		c) flag_clone=true;;
		s) privileges true false;;
		r) privileges false true;;
		v) echo "$version"; exit 0;;
		h) usage; exit 1;;
		*) exit 2;;
	esac
done
shift $((OPTIND-1))

token="$1"
: ${clone_type:?must be set}
: ${token:?must be set}

# ***** PROGRAM START *****
declare -A clone_map=(['http']='clone_url' ['ssh']='ssh_url')

page='1'
while :; do
	eval "$( {
		body="$( curl -fsSL \
			-D >( headers="$(< /dev/stdin)"; declare -p headers >&3 ) \
			-H 'Accept: application/vnd.github+json' \
			-H "Authorization: Bearer $token" \
			-H 'X-GitHub-Api-Version: 2026-03-10' \
			"https://api.github.com/user/repos?type=owner&per_page=100&page=$page"
		)"
		declare -p body >&3
	} 3>&1 )"

	for url in $(jq -r ".[].${clone_map[$clone_type]}" <<< "$body"); do
		if ${flag_clone:-false}; then
			git clone "$url"
		else
			echo "$url"
		fi
	done

	if ! grep -qP '^link:.*rel="next"' <<< "$headers"; then
		break
	fi

	let page++
done
