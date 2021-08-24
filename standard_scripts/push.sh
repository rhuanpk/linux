#!/bin/bash

if($1 == null) {
	$1 = "refresh";
}

git add . ;
git commit -m "$1" ;
git push origin master
