#!/usr/bin/env bash

# Make a list of the packages dependencies of the programs to temp files.

verify_privileges() {
        if [ ${UID} -eq 0 ]; then
                echo -e "ERROR: Run this program without privileges!\nExiting..."
                exit 1
        fi
}

print_usage() {
        cat <<- EOF
		#########################################################################
		#
		# Pass as a parameter the program you want to download the dependencies.
		#
		# Example:
		#
		# 	$(basename ${0}) vim
		#
		#########################################################################
	EOF
}

verify_privileges

[ ${#} -lt 1 -o "${1,,}" = '-h' -o "${1,,}" = '--help' ] && {
        print_usage
        exit 1
}

# >>>>> PROGRAM START <<<<<

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
