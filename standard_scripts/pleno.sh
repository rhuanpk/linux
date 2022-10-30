#!/usr/bin/env bash

# Script that updates, fixes and cleans the system in one go.

verify_privileges() {
        if [ ${UID} -eq 0 ]; then
                echo -e "ERROR: Run this program without privileges!\nExiting..."
                exit 1
        fi
}

print_usage() {
        echo -e "Run:\n\t./$(basename ${0})"
}

verify_privileges

[ ${#} -ge 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>>>> PROGRAM START <<<<<

# Fix
sudo dpkg --configure -a
sudo apt install -f -y
sudo apt --fix-broken install -y

# Update
sudo apt update -y
sudo apt upgrade -y

sudo ubuntu-drivers autoinstall
sudo apt install ubuntu-restricted-extras -y

# Clean
sudo apt clean -y
sudo apt autoclean -y
sudo apt autoremove -y

# Update and Clean
sudo apt dist-upgrade -y
sudo apt full-upgrade -y
