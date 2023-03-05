#!/usr/bin/env bash

# Remove the next line of pattern if him is blank.

# >>> variable declarations !

format_red='\e[31m'
format_green='\e[32m'
format_yellow='\e[33m'
format_cyan='\e[36m'
format_bold='\e[1m'
format_underlined='\e[4m'
format_reset='\e[m'

readonly script=$(basename "${0}")
readonly version=0.0.0
readonly home=${HOME:-/home/${USER:-$(whoami)}}

getopt_short_options='hvm:f:t:'
getopt_long_options='help,version,pattern:,pathway:,typeof:'

regex_default='(-h|--help|-v|--version)'
regex_requires='(-m|--pattern).*(-f|--pathway).*(-t|--typeof)'

log_file=`mktemp /tmp/${script}_XXXXXXXXXXXXXX.log`

# >>> function declarations !

print_usage() {
	cat <<- eof
		####################################################################################################
		#
		# >>> `echo -e ${format_bold}${script}${format_reset}` !
		#
		# DESCRIPTION
		# 	Script for remove next line blank of the line pattern match.
		#
		# USAGE
		# 	$script [-hv] -m <argument> -f <argument> -t <typeof>
		#
		# REQUIRES
		#	-m, --pattern '<argument>'
		# 		Is <argument> a string single quoted with the regex pattern (perl/grep).
		#
		# 	and
		#
		#	-f, --pathway <argument>
		# 		Is <argument> a pathway to the file or directory (whithout backslash) to search.
		#
		# 	and
		#
		# 	-t, --typeof <typeof> 
		# 		See `echo -e ${format_underlined}TYPEOF${format_reset}` section for <typeof> options.
		#
		# OPTIONALS
		# 	-v, --version
		# 		Print the versions and exit with 0.
		#
		# 	-h, --help
		# 		Print this help and exit with 0.
		#
		# TYPEOF
		# 	Options for <typeof> argument.
		#
		# 	f, file
		# 		Option for execute from a single file.
		#
		# 	d, directory
		# 		Option for all files in a directory.
		#
		####################################################################################################
	eof
}

print_version() {
	echo -e "${format_bold}${script}${format_reset}: version ${version}!"
}

print_leaving() {
	echo -e "${format_green}thanks${format_reset}..."
	exit 0
}

print_exiting() {
	echo -e "${format_yellow}exiting${format_reset}..." >&2
	exit 1
}

verify_privileges() {
	[ $UID -eq 0 ] && {
		echo -e "${format_red}ERROR${format_reset}: run this program ${format_bold}without${format_reset} privileges!" >&2
		print_exiting
	}
}

iffnue() {
	read -rp 'remove next blank lines? [y/N] ' answer
	([ -z "${answer}" ] || [ y != "${answer,,}" ])
}

remove_nonprinting() {
	file=${1:?need specify a file to remove noprinting characters!}
	cat -v $file | sed -E 's~\^\[\[([[:digit:]]+;?)*m\^\[\[K~~g'
}

format_make_cyan() {
	string=${1:?need a string to format in cyan!}
	echo -e "${format_cyan}${string}${format_reset}"
}

# >>> pre statements !

set +o histexpand

#verify_privileges

if ! options=`getopt -l $getopt_long_options -n $script -- $getopt_short_options "${@}"`; then
	print_exiting
elif ! [[ $options =~ $regex_default || $options =~ $regex_requires ]]; then
	echo -e "\
		\r${script}: ${format_red}missing required options${format_reset}!\n\
		\r${script}: ${format_bold}-h${format_reset} or ${format_bold}--help${format_reset} to see!\
	" >&2
	print_exiting
fi
eval "set -- ${options}"
while :; do
	option="${1}"
	argument="${2}"
	case $option in
		-m|--pattern) pattern="${argument}"; shift 2;;
		-f|--pathway) pathway="${argument}"; shift 2;;
		-t|--typeof) typeof="${argument}"; shift 2;;
		-v|--version) print_version; exit 0;;
		-h|--help) print_usage; exit 0;;
		--) shift; break;;
		*) echo -e "${format_red}script panic${format_reset}!"; exit 1;;
	esac
done

# >>> *** PROGRAM START *** !
cat <<- eof
	>>> ${script} !

	`format_make_cyan pattern`: ${pattern:?need a pattern to match!}
	`format_make_cyan pathway`: ${pathway:?need a pathway to find!}
	`format_make_cyan typeof`: ${typeof:?need a typeof to specify!}

	logfile: $log_file

eof

if [ "${typeof,,}" = f ] || [ "${typeof,,}" = file ]; then
	eval "grep --color=always -nFA 1 '${pattern}' '${pathway%/}'" | tee $log_file | less -R
	if ! iffnue; then
		for log_line in $(seq 2 3 `wc -l < $log_file`); do
			blank_line=`remove_nonprinting $log_file | tail -n +${log_line} | head -1 | cut -d - -f 1`
			#sed -i `bc <<< "${blank_line}-${count:-0}"`d $pathway
			sed -i "$((${blank_line}-${count:-0}))d" $pathway
			let count++
		done
	else
		print_leaving
	fi
elif [[ "${typeof,,}" = d || "${typeof,,}" = directory ]]; then
	eval "grep --color=always -nrIFA 1 '${pattern}' '${pathway}/'" | tee $log_file | less -R
else
	echo -e "${script}: ${format_red}incorrect${format_reset} typeof argument!" >&2
	print_exiting
fi
