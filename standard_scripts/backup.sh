#!/usr/bin/env bash

arquivo="$(date +"%d-%m-%y_backup").tar.gz"
busca=("/tmp/temp1/" "/tmp/temp2/" "/tmp/temp3/")
main="${HOME}/backup"
destino="/tmp/temp"

rm -rf ${destino}/*.tar.gz

for (( i = 0; i < ${#busca[@]}; ++i )); do
	cp -r ${busca[i]} ${main}
done

tar -zcvf ${destino}/${arquivo} ${main}
