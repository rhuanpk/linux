#!/usr/bin/env bash
get_number_lines() {
	file=$1
	echo $(wc -l < $file)
}
package=$1
packages_file_main=/tmp/apt_download_packages_main.txt
packages_files_tmp=/tmp/apt_download_packages_tmp.txt
echo $package > $packages_file_tmp > $packages_file_main
while :; do
	old_lines=$(get_number_lines $packages_file_main)
	echo "" > ${all_packages_files_tmp}
	for pkg in $(cat ${all_packages_files_tmp}); do
		apt-cache depends $pkg | tr -d '^[:blank:]' | grep -iF depends | cut -d ':' -f 2 > ${packages_files_tmp} >> ${all_packages_files_tmp}
		cat <<- eof > $packages_file_main
			$(sort -u $(cat ${packages_file_main} ${packages_file_tmp}))
		eof
	done
	new_lines=$(get_number_lines $packages_file_main)
	[ $new_lines -le $old_lines ] && exit 0
done
