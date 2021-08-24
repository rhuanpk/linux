#!/bin/bash

if [ -z '$1' ]; then
	'$1' = 'refresh'
fi

git add . ;
git commit -m '$1' ;
git push origin master
