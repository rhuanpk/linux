#!/bin/bash

indexed-array() {
	cat <<- \eof
		===== Indexed Array =====

		$ array=(foo bar 'boo baz' xpto "$(pwd)")
	eof
	array=(foo bar 'boo baz' xpto "$(pwd)")

	# ---------------------------------------

	cat <<- \eof

		$ echo "$array"
	eof
	echo "$array"

	# ---------------------------------------

	cat <<- \eof

		$ echo "${array[1]}"
	eof
	echo "${array[1]}"

	# ---------------------------------------

	cat <<- \eof

		$ echo "${array[-2]}"
	eof
	echo "${array[-2]}"

	# |--------------------------------------

	cat <<- \eof

		$ echo "${#array}"
	eof
	echo "${#array}"

	# ---------------------------------------

	cat <<- \eof

		$ echo "${#array[1]}"
	eof
	echo "${#array[1]}"

	# ---------------------------------------

	cat <<- \eof

		$ echo "${#array[-2]}"
	eof
	echo "${#array[-2]}"

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

		$ echo "${array[@]:3}"
	eof
	echo "${array[@]:3}"

	# ---------------------------------------

	cat <<- \eof

		$ echo "${array[@]:3:1}"
	eof
	echo "${array[@]:3:1}"

	# ---------------------------------------

	cat <<- \eof

		$ echo "${array[@]: -2}"
	eof
	echo "${array[@]: -2}"

	# ---------------------------------------

	cat <<- \eof

		$ echo "${array[@]: -2:1}"
	eof
	echo "${array[@]: -2:1}"

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

indexed-array-for() {
	cat <<- \eof

		===== Indexed Array For =====

		$ array=(foo bar 'boo baz' xpto "$(pwd)")
	eof
	array=(foo bar 'boo baz' xpto "$(pwd)")

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
}

indexed-array
indexed-array-for
