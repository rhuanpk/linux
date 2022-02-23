#!/usr/bin/env bash

file=${1}

for i in $(seq $(grep -n '^[[:blank:]]*+' ${file} | wc -l)); do
	line=$(grep -n '^[[:blank:]]*+' ${file} | sed -n "${i}p" | cut -c '1')
	next_line=$((${line}+1))
	cont_next_line=$(sed -n "${next_line}p" ${file})
	[ -z ${cont_next_line:+foobar} ] && sed -i "${next_line}d" ${file}
done

sed -i 's/^[[:blank:]]*+//g' ${file}
