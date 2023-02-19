#!/usr/bin/env bash

# Script that updates, fixes and cleans the system in one go.

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

# Fix
sudo -v
sudo dpkg --configure -a
sudo apt install -f -y
sudo apt --fix-broken install -y

# Update
sudo -v
sudo apt update -y
sudo apt upgrade -y
sudo apt list --upgradable 2>&- | sed -nE 's~^(.*)/.*$~\1~p' | xargs sudo apt install -y

sudo ubuntu-drivers autoinstall
sudo apt install ubuntu-restricted-extras -y

# Clean
sudo -v
sudo apt clean -y
sudo apt autoclean -y
sudo apt autoremove -y

# Update and Clean
sudo -v
sudo apt dist-upgrade -y
sudo apt full-upgrade -y
