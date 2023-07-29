#!/usr/bin/env bash
sudo='sudo'
setload() {
	variable_name=${1:?'need a variable to set!'}
	repo_name=${2:?'needs the name of the repository to be loaded!'}
	home=/home/$(id -nu 1000)
        environment_path=/etc/environment
	full_path=$(
		folders='pCloudDrive|googleDrive'
		find ${home}/ -type f -name ".way-flag-${repo_name}.cfg" 2>&- \
		| sed -E "/${folders:-$(uuidgen)}/d" \
		| xargs dirname 2>&- \
		| tail -1
	)
	line_and_path=$(grep -nE "${variable_name}=.*$" ${environment_path:?'whats the environment path?'})
	[ ! -z "${line_and_path}" ] && {
		if ! $sudo sed -i "${line_and_path%:*}s~=${line_and_path#*=}~=${full_path}~" ${environment_path}; then
			echo $full_path
		fi
	} || echo $full_path
}
[ '-w' = "$1" ] && { unset sudo; shift; }
setload PK_LOAD_CFGBKP cfg-bkp
setload PK_LOAD_LINUX linux
#setload PK_LOAD_PKUTILS pkutils
