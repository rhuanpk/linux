#!/usr/bin/env bash

setload() {
	variable_name=${1:?'need a variable to set!'}
	repo_name=${2:?'needs the name of the repository to be loaded!'}
	file_load=${3:?'needs the path of the file to be loaded!'}
	home=/home/$(id -nu 1000)
        environment_path=/etc/environment
	full_path=$(
		folders='pCloudDrive|googleDrive'
		find ${home}/ -type f -name ".way_flag_${repo_name}.cfg" 2>&- | \
		sed -E "/${folders:-$(uuidgen)}/d" | \
		xargs dirname
	)/${file_load}
	line_and_path=$(grep -nE "${variable_name}=.*$" ${environment_path:?'whats the environment path?'})
	sudo sed -i "${line_and_path%:*}s~${line_and_path#*=}~${full_path}~" ${environment_path}
}

setload PK_LOAD_ZBASHRC cfg-bkp rc/zbashrc
setload PK_LOAD_STANDARDUTILS pkutils bash/
