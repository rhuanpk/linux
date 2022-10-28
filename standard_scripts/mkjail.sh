#!/usr/bin/env bash

# Cria um exemplo de jaula e se muda para lá.

verify_privileges() {
        if [ ${UID} -eq 0 ]; then
                echo -e "ERROR: Run this program without privileges!\nExiting..."
                exit 1
        fi
}

print_usage() {
        cat <<- eof
		##################################################
		#
		# $(basename ${0}) make a jail and move it.
		#
		# run:
		# 	$(basename ${0}) [/path/to/tmp/jail]
		#
		##################################################
	eof
}

verify_privileges

[ ${#} -ge 2 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>>>> PROGRAM START <<<<<

jail_path=${1:-/tmp/jail}
[ -d ${jail_path}/ ] && rm -rf ${jail_path}/
mkdir -p ${jail_path}/{lib/x86_64-linux-gnu/,lib64/,usr/bin/}
cp /usr/bin/{bash,ls} ${jail_path}/usr/bin/
cp /lib/x86_64-linux-gnu/{libselinux.so.1,libc.so.6,libpcre2-8.so.0,libtinfo.so.6} ${jail_path}/lib/x86_64-linux-gnu/
cp /lib64/ld-linux-x86-64.so.2 ${jail_path}/lib64/
sudo chroot ${jail_path}/ /usr/bin/bash
