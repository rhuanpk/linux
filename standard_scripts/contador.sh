#!/usr/bin/env bash

read foo
bar=${foo}
clear
echo -ne "  >>> CONTADOR = ${bar} !\r"

while : ; do
	read foo 
	let bar+=${foo}
	clear
	echo -ne "  >>> CONTADOR = ${bar} !\r"
done
