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

define_work_dir() {
	path_folder=$1
	[ ! -d $path_folder ] && { mkdir $path_folder && cd $path_folder ;} || { cd $path_folder && rm -rf ./* ;}
}

package=$1
work_path=/tmp/apt_download
zstd_work_path=/tmp/apt_download/zstd
packages_file=${work_path}/packages_file.txt

define_work_dir $work_path

apt-cache depends --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances $package > $packages_file
apt-cache rdepends --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances  $package >> $packages_file

tr -d '^[[:blank:]]' < $packages_file | grep -vF i386 | cut -d ':' -f 2 | grep -E '^\w' | sort -u | xargs sudo apt download -y

define_work_dir $zstd_work_path

cp -v ${work_path}/*.deb ${zstd_work_path}/
for deb_file in $(ls -1); do
	ar x $deb_file
	unzstd control.tar.zst
	unzstd data.tar.zst
	xz control.tar
	xz data.tar
	rm $deb_file
	ar cr $deb_file debian-binary control.tar.xz data.tar.xz
	rm *.{xz,zst}; rm debian-binary
done
