#!/usr/bin/env bash

path="${HOME}/Documents/git"
repo=$(ls -1 ${path} | sed 's/$/ /g' | tr -d '\n')

for dir in ${repo}; do
	cd ${path}/${dir}
	push.sh
done
