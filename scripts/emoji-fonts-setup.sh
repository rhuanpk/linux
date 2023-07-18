#!/usr/bin/env bash

# Setup packages and dot files for emoji fonts.

# >>> variable declarations !

script=$(basename "${0}")
home=${HOME:-/home/${USER:-$(whoami)}}

# >>> function declarations !

verify_privileges() {
	[ $UID -eq 0 ] && {
		echo -e "ERROR: Run this program without privileges!\nExiting..."
		exit 1
	}
}

print_usage() {
        echo -e "Run:\n\t./${script}"
}

# >>> pre statements !

set +o histexpand

verify_privileges
[ $# -ge 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>> *** PROGRAM START *** !
packages=(fonts-symbola fonts-noto-color-emoji)
pathway=$HOME/.config/fontconfig/conf.d

for package in ${packages[@]}; do
	if ! dpkg -s $package &>/dev/null; then
		echo "this script needs the $package package but not installed, it will be installed!"
		if sudo apt install -y $package; then
			echo "package $package that's ok!"
		else
			cat <<- eof
				some wrong occured with package $package
				exiting (with 1) without complete the script...
			eof
		fi
	fi
done

mkdir -pv "$pathway"
cat << \eof > $pathway/fonts.conf
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
	<!-- ## serif ## -->
	<alias>
		<family>serif</family>
		<prefer>
			<family>Noto Serif</family>
			<family>emoji</family>
			<family>Liberation Serif</family>
			<family>Nimbus Roman</family>
			<family>DejaVu Serif</family>
		</prefer>
	</alias>
	<!-- ## sans-serif ## -->
	<alias>
		<family>sans-serif</family>
		<prefer>
			<family>Noto Sans</family>
			<family>emoji</family>
			<family>Liberation Sans</family>
			<family>Nimbus Sans</family>
			<family>DejaVu Sans</family>
		</prefer>
	</alias>
</fontconfig>
eof
fc-cache -f

echo "all done, restart the applications to see the changes!"
