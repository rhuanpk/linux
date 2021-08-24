#!/usr/bin/env bash

[[ "$1" == "" ]] && value='refresh!' || value="$1"

git add . ;
git commit -m "$value" ;
git push origin master
