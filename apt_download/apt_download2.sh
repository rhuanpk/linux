#!/usr/bin/env bash
get_number_lines() {
	file=$1
	echo $(wc -l < $file)
}
package=$1
packages_file_main=/tmp/apt_download_packages_main.txt
packages_file_tmp=/tmp/apt_download_packages_tmp.txt
all_packages_file_tmp=/tmp/apt_download_all_packages_tmp.txt
echo $package > $packages_file_tmp
echo $package > $packages_file_main
echo $package > $all_packages_file_tmp
while :; do
	old_lines=$(get_number_lines $packages_file_main)
	read readkey
	# echo "" > ${all_packages_file_tmp}
	for pkg in $(cat ${all_packages_file_tmp}); do
		apt-cache depends $pkg | tr -d '^[:blank:]' | grep -iF depends | cut -d ':' -f 2 > ${packages_file_tmp}
		cat ${packages_file_tmp} >> ${all_packages_file_tmp}
		read readkey
		cat <<- eof > $packages_file_main
			$(sort -u $(cat ${packages_file_main} ${packages_file_tmp}))
		eof
		read readkey
	done
	read readkey
	new_lines=$(get_number_lines $packages_file_main)
	read readkey
	[ $new_lines -le $old_lines ] && exit 0
	read readkey
done
