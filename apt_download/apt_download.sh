get_number_lines() {
	file=$1
	echo $(wc -l < $file)
}
package=$1
packages_file=/tmp/apt_download_packages.txt
echo $package > $packages_file
while read pkg; do
	old_lines=$(get_number_lines $packages_file)
	apt-cache depends $pkg | tr -d '^[:blank:]' | grep -iF depends | cut -d ':' -f 2 >> ${packages_file}
	cat <<- eof > $packages_file
		$(sort -u ${packages_file})
	eof
	new_lines=$(get_number_lines $packages_file)
	[ $new_lines -le $old_lines ] && exit 0
done < $packages_file
