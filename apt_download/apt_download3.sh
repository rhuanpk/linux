#!/usr/bin/env bas

package=$1
packages_file=/tmp/apt_download_packages_file.txt
work_path=/tmp/apt_download

[ ! -d $work_path ] && { mkdir $work_path && cd $work_path ;} || { cd $work_path && rm -rf ./* ;}

apt-cache depends --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances $package > $packages_file
apt-cache rdepends --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances  $package >> $packages_file

tr -d '^[[:blank:]]' < $packages_file | grep -vF i386 | cut -d ':' -f 2 | grep -E '^\w' | sort -u | xargs sudo apt download -y