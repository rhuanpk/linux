#!/usr/bin/env bash
get_number_lines() {
	file=$1
	echo $(wc -l < $file)
}
package=$1
packages_file_main=/tmp/apt_download_packages_main.txt
packages_file_tmp=/tmp/apt_download_packages_tmp.txt
flag=true
echo $package > $packages_file_main
while ${flag}; do
	old_lines=$(get_number_lines $packages_file_main)
	for pkg in $(cat ${packages_files_main}); do
		apt-cache depends $pkg | tr -d '^[:blank:]' | grep -iF depends | cut -d ':' -f 2 > ${packages_file_tmp}
		cat <<- eof > $packages_file_main
			$(sort -u ${packages_file_main})
		eof
		new_lines=$(get_number_lines $packages_file_main)
		[ $new_lines -le $old_lines ] && exit 0
	done
done
