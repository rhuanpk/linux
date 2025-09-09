#!/bin/bash

# this script calculate the conversion of px to em in css
# only by values multiple of 4 with base of size 62.5%

# convert * divider = proportion
# convert = proportion / divider

proportion='4' #"${1:?needs a proportion}"
proportion_unit='px' #"${2:?needs a proportion unit}"
base_divider='10' #"${3:?needs a base divider}"
base_unit='px' #"${4:?needs a base unit}"
convert_unit='em' #"${5:?needs a convert unit}"
range_start="${1:?needs a start range}" #"${6:?needs a start range}"
range_end="${2:?needs a end range}" #"${7:?needs a end range}"

range_start_chars="$(echo -n "$range_start" | wc -m)"
range_end_chars="$(echo -n "$range_end" | wc -m)"
blank_spaces="$range_start_chars"
(( blank_spaces < range_end_chars )) && blank_spaces="$range_end_chars"

#for index in $(eval "echo {$range_start..$range_end}"); do
for index in $(seq $range_start $range_end); do
	(( index % proportion == 0 )) && proportions+=("$index")
done

for proportion in ${proportions[@]}; do
	(( proportion == 0 )) && result='0' || result="$(bc <<< "scale=1; $proportion / $base_divider")"
	eval "printf '%${blank_spaces}d%s / %d%s = %.1f%s\n' \
		'$proportion' '$proportion_unit' '$base_divider' '$base_unit' '$result' '$convert_unit'"
done
