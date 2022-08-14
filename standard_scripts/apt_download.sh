#!/usr/bin/env bash

# Baixa somente o .deb do programa e suas libs

verify_privileges() {
        if [ ${UID} -eq 0 ]; then
                echo -e "ERROR: Run this program without privileges!\nExiting..."
                exit 1
        fi
}

print_usage() {
	cat <<- eof
		###################################################################
		#
		# Pass like first param the program witch you want downlaod, e.g.:
		#
		# 	$(basename $0) <program>
		#
		###################################################################
	eof
}

verify_privileges

[ ${#} -lt 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>>>> PROGRAM START <<<<<

package=$1
work_path=/tmp/apt_download
packages_file=${work_path}/packages_file.txt

[ ! -d $work_path ] && { mkdir $work_path && cd $work_path ;} || { cd $work_path && rm -rf ./* ;}

apt-cache depends --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances $package > $packages_file
apt-cache rdepends --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances  $package >> $packages_file

tr -d '^[[:blank:]]' < $packages_file | grep -vF i386 | cut -d ':' -f 2 | grep -E '^\w' | sort -u | xargs sudo apt download -y
