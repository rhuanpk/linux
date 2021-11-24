#!/usr/bin/env bash

read foo
[ "${foo,,}" == "q" ] && exit 0
bar=${foo}
clear
echo -ne "  >>> CONTADOR = ${bar} !\r"

while : ; do
	read foo 
	[ "${foo,,}" == "q" ] && exit 0
	let bar+=${foo}
	clear
	echo -ne "  >>> CONTADOR = ${bar} !\r"
done
