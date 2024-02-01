#!/usr/bin/bash

# Generates figlet banners by given text.

# >>> variables declaration!
readonly version='1.0.0'
readonly script="`basename "$0"`"
readonly uid="${UID:-`id -u`}"

SUDO='sudo'

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Generates figlet banners by given text.

Usage: $script [<options>] <text>

Options:
	-u: Do the setup for figlet fonts;
	-q: Do not print output, only and generates the file;
	-l: List all font names;
	-f '<font1[|font2...]>': Filter by font name(s) (without your extension);
	-s: Forces keep sudo;
	-r: Forces unset sudo;
	-v: Print version;
	-h: Print this help.
EOF
}

privileges() {
	FLAG_SUDO="${1:?needs sudo flag}"
	FLAG_ROOT="${2:?needs root flag}"
	if [[ -z "$SUDO" && "$uid" -ne 0 ]]; then
		echo "$script: error: run with root privileges"
		exit 1
	elif ! "$FLAG_SUDO"; then
		if "$FLAG_ROOT" || [ "$uid" -eq 0 ]; then
			unset SUDO
		fi
	fi
}

check-needs() {
	privileges false false
	PACKAGES=('figlet')
	for package in "${PACKAGES[@]}"; do
		if ! dpkg -s "$package" &>/dev/null && ! which -s "$package"; then
			read -p "$script: info: is needed the \"$package\" package, install? [Y/n] " answer
			[ -z "$answer" ] || [ 'y' = "${answer,,}" ] && $SUDO apt install -y "$package"
		fi
	done
}

setup() {
	cd /usr/share/ \
	&& $SUDO git clone 'https://github.com/xero/figlet-fonts' \
	&& $SUDO mv ./figlet-fonts/* ./figlet/ \
	&& $SUDO rm -rf ./figlet-fonts/ \
	&& MESSAGE='all done' || MESSAGE='something went wrong'
	echo "$script: setup finished, $MESSAGE"
}

list-fonts() {
	ls -1 /usr/share/figlet/*.{flf,tlf} | less -R
}

# >>> pre statements!
check-needs

while getopts 'uqlf:srvh' option; do
	case "$option" in
		u) setup; exit;;
		q) FLAG_QUIET='true';;
		l) list-fonts; exit;;
		f) FILTER="$OPTARG";;
		s) privileges true false;;
		r) privileges false true;;
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
TEXT="${1:?needs a text to banner}"
COLS="`tput cols`"
FILE="$(mktemp "/tmp/figlet_`cut -d ' ' -f 1 <<< "$TEXT"`_XXXXXXX-`date +'%y%m%d%H%M%S'`.txt")"
for font in /usr/share/figlet/*.{flf,tlf}; do
	FONT="`basename "${font%.*}"`"
	if test "$FILTER" && ! [[ "$FONT" =~ ^($FILTER)$ ]]; then continue; fi
	if BANNER="`figlet -w "$COLS" -f "$FONT" "$TEXT" 2>&-`"; then
		if ! "${FLAG_QUIET:-false}"; then
			cat <<- EOF | tee -a "$FILE"
				>>> $FONT <<<
				$BANNER

			EOF
		else
			echo ">>> $FONT <<<" >> "$FILE"
			echo "$BANNER" >> "$FILE"
			echo >> "$FILE"
		fi
	fi
done
echo "$script: log file: \"$FILE\""
