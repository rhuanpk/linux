#!/usr/bin/env bash

repo_name=${1:?'needs the name of the repository to be loaded!'}
file_load=${2:?'needs the path of the file to be loaded!'}
echo $(
	folders='pCloudDrive|googleDrive'
	find ~/ -type f -name "way_flag_${repo_name}.cfg" 2>&- | \
	sed -E "/${folders:-$(uuidgen)}/d" | \
	xargs dirname
)/${file_load}
