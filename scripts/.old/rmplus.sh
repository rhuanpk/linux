#!/usr/bin/env bash

file=${1}

# Caso encontre alguma linha cujo primeiro caracter seja um "+" e a linha de baixo for em branco então remova-a
for i in $(seq $(grep -n '^[[:blank:]]*+' ${file} | wc -l)); do
	line=$(grep -n '^[[:blank:]]*+' ${file} | sed -n "${i}p" | cut -c '1')
	next_line=$((${line}+1))
	cont_next_line=$(sed -n "${next_line}p" ${file})
	[ -z ${cont_next_line:+foobar} ] && sed -i "${next_line}d" ${file}
done

control=$(grep -c '^[[:blank:]]*+' ${file})

# Remove SOMENTE o caracter "+" do início da linha
for ((i=0;i<${control};++i)); do
        linha=$(grep -n '^[[:blank:]]*+' ${file} | cut -d ':' -f 1 | sed -n "1p")
        content=$(grep -o '^[[:blank:]]*+' ${file} | sed -n "1p")
        treated=$(echo "${content}" | tr -d '+')
        sed -i "${linha}s/^${content}/${treated}/" ${file}
done
