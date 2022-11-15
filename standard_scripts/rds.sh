#!/usr/bin/env bash

# Report Disk Synchronization (RDS).
# Is a script that simply monitors disk synchronization.
#
# DISCLAIMER: This script is from some good guy on the internet.

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

# Output the *Dirty* section of `/proc/meminfo`
report() {
	dirty=$(grep -F Dirty: /proc/meminfo | sed -E 's/^(.*:[[:blank:]]+)//')
	echo -en "\r\e[2mSyncing ${dirty}...\e[m"
}

# Start syncing
sync &
sync_pid=${!}

# Give a short sleep in case there's not much
sleep .5

# While sync is running, report
while ps -p $sync_pid &>/dev/null; do
	report
	sleep 1
done

echo 'Done!'
