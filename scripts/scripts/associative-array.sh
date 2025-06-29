#!/bin/bash

associative-array() {
	cat <<- \eof
		===== Associative Array =====

		$ declare -A array=([zero]=foo ['one']=bar ["two"]='boo baz' [three]=xpto ['fo ur']="$(pwd)")
	eof
	declare -A array=([zero]=foo ['one']=bar ["two"]='boo baz' [three]=xpto ['fo ur']="$(pwd)")

	# ---------------------------------------

	cat <<- \eof

		$ echo "${array[zero]}"
	eof
	echo "${array[zero]}"

	# ---------------------------------------

	cat <<- \eof

		$ echo "${array["fo ur"]}"
	eof
	echo "${array["fo ur"]}"

	# |--------------------------------------

	cat <<- \eof

		$ echo "${#array[one]}"
	eof
	echo "${#array[one]}"

	# ---------------------------------------

	cat <<- \eof

		$ echo "${#array['fo ur']}"
	eof
	echo "${#array['fo ur']}"

	# ---------------------------------------

	cat <<- \eof

		$ echo "${#array[@]}"
	eof
	echo "${#array[@]}"

	# ---------------------------------------

	cat <<- \eof

		$ echo "${#array[*]}"
	eof
	echo "${#array[*]}"

	# |--------------------------------------

	cat <<- \eof

		$ echo "${!array[@]}"
	eof
	echo "${!array[@]}"

	# ---------------------------------------

	cat <<- \eof

		$ echo "${!array[*]}"
	eof
	echo "${!array[*]}"

	# |--------------------------------------

	cat <<- \eof

		$ echo ${array[@]}
	eof
	echo ${array[@]}

	# ---------------------------------------

	cat <<- \eof

		$ echo "${array[@]}"
	eof
	echo "${array[@]}"

	# ---------------------------------------

	cat <<- \eof

		$ echo ${array[*]}
	eof
	echo ${array[*]}

	# ---------------------------------------

	cat <<- \eof

		$ echo "${array[*]}"
	eof
	echo "${array[*]}"
}

associative-array-for() {
	cat <<- \eof
		===== Associative Array For =====

		$ declare -A array=([zero]=foo ['one']=bar ["two"]='boo baz' [three]=xpto ['fo ur']="$(pwd)")
	eof
	declare -A array=([zero]=foo ['one']=bar ["two"]='boo baz' [three]=xpto ['fo ur']="$(pwd)")

	# ---------------------------------------

	cat <<- \eof

		$ for value in ${array[@]}
	eof
	for value in ${array[@]}; do
		#echo "$value"
		echo "${value@Q}"
	done

	# ---------------------------------------

	cat <<- \eof

		$ for value in "${array[@]}"
	eof
	for value in "${array[@]}"; do
		#echo "$value"
		echo "${value@Q}"
	done

	# ---------------------------------------

	cat <<- \eof

		$ for value in ${array[*]}
	eof
	for value in ${array[*]}; do
		#echo "$value"
		echo "${value@Q}"
	done

	# ---------------------------------------

	cat <<- \eof

		$ for value in "${array[*]}"
	eof
	for value in "${array[*]}"; do
		#echo "$value"
		echo "${value@Q}"
	done

	# |--------------------------------------

	cat <<- \eof

		$ for value in ${!array[@]}
	eof
	for value in ${!array[@]}; do
		#echo "$value"
		echo "${value@Q}"
	done

	# ---------------------------------------

	cat <<- \eof

		$ for value in "${!array[@]}"
	eof
	for value in "${!array[@]}"; do
		#echo "$value"
		echo "${value@Q}"
	done

	# ---------------------------------------

	cat <<- \eof

		$ for value in ${!array[*]}
	eof
	for value in ${!array[*]}; do
		#echo "$value"
		echo "${value@Q}"
	done

	# ---------------------------------------

	cat <<- \eof

		$ for value in "${!array[*]}"
	eof
	for value in "${!array[*]}"; do
		#echo "$value"
		echo "${value@Q}"
	done
}

associative-array
associative-array-for
