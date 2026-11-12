#!/usr/bin/bash

#AUTHOR=rhuanpk;EMAIL=dev@rhuanpk.net

folder='/tmp/tmp'
[ ! -d "$folder/" ] && mkdir -pv "$folder/"
cd "$folder/"; clear; exec startx
