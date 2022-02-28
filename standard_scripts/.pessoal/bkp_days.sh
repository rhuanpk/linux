#!/usr/bin/env bash

year=$(date "+%Y")
month=$(date "+%m")
day=$(date "+%d")
before_day=$((${day}-2))

# diferença é maior que dois?

[ ${day} -le ${before_day} ] && echo "é menor"

###############################################

# day= #dia do arquivo
diference=$((${day}-$(date "+%d")))
