#!/usr/bin/env bash
package=${1}
dependencies=$(mktemp /tmp/apt_dependencies_${package}_XXXXXXXXXX.tmp)
rdependencies=$(mktemp /tmp/apt_rdependencies_${package}_XXXXXXXXXX.tmp)
file=${dependencies}
for option in depends rdepends; do
	apt-cache ${option}\
		--recurse\
		--no-recommends\
		--no-suggests\
		--no-conflicts\
		--no-breaks\
		--no-replaces\
		--no-enhances\
		${package} | sed 's/^ \|^<\|.*Depends: \|>$//g' | sed 's/^<\|^ *//g' | sed '/:i386$/d' > ${file}
	atual_line=1
	while :; do
		total_lines=$(wc -l ${file} | cut -d ' ' -f 1)
		if [ ! ${atual_line} -ge ${total_lines} ]; then
			content_line=$(sed -n "${atual_line}p" ${file})
			next_line=$((${atual_line}+1))
			for ((index=${next_line}; index<=${total_lines}; ++index)); do
				next_content_line=$(sed -n "${index}p" ${file})
				[ "${content_line}" = "${next_content_line}" ] && sed -i "${index}d" ${file}
			done
		else
			exit
		fi
		let ++atual_line
	done
	file="${rdependencies}"
done
