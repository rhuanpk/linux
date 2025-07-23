#!/usr/bin/bash

# Remove the next line of pattern if him is blank.

# >>> built-in sets!
set +o histexpand

# >>> variables declaration!
readonly version='2.0.0'
readonly script="`basename "$0"`"

FORMAT_RED='\e[31m'
FORMAT_GREEN='\e[32m'
FORMAT_YELLOW='\e[33m'
FORMAT_CYAN='\e[36m'
FORMAT_BOLD='\e[1m'
FORMAT_UNDERLINED='\e[4m'
FORMAT_RESET='\e[m'

GETOPT_SHORT_OPTIONS='hvm:f:t:'
GETOPT_LONG_OPTIONS='help,version,pattern:,pathway:,typeof:'

REGEX_DEFAULT='(-h|--help|-v|--version)'
REGEX_REQUIRES='(-m|--pattern).*(-f|--pathway).*(-t|--typeof)'

LOG_FILE="`mktemp /tmp/$script-XXXXXXXXXX.log`"

# >>> functions declaration!
print-usage() {
cat << EOF
$script v$version

DESCRIPTION
	Script to remove the next blank line referring to the line to be searched for the informed
	regex pattern.

	E.g. if I look for the pattern '.*line with this expression$', the script will remove all
	the lines whose next line of this expression is blank.

USAGE
	$script [-hv] -m <argument> -f <argument> -t <typeof>

REQUIRES
	-m, --pattern '<argument>'
		Is <argument> a string single quoted with the regex pattern (perl/grep).

	and

	-f, --pathway <argument>
		Is <argument> a pathway to the file or directory (whithout backslash) to search.

	and

	-t, --typeof <typeof> 
		See `echo -e ${FORMAT_UNDERLINED}TYPEOF${FORMAT_RESET}` section for <typeof> options.

OPTIONALS
	-v, --version
		Print the versions and exit with 0.

	-h, --help
		Print this help and exit with 0.

TYPEOF
	Options for <typeof> argument.

	f, file
		Option for execute from a single file.

	d, directory
		Option for all files in a directory.
EOF
}

print-version() {
	echo -e "${FORMAT_BOLD}${script}${FORMAT_RESET}: version ${version}!"
}

print-leaving() {
	echo -e "${FORMAT_GREEN}thanks${FORMAT_RESET}..."
	exit 0
}

print-exiting() {
	echo -e "${FORMAT_YELLOW}exiting${FORMAT_RESET}..." >&2
	exit 1
}

iffnue() {
	read -rp 'remove next blank lines? [y/N] ' answer
	([ -z "$answer" ] || [ y != "${answer,,}" ])
}

remove-nonprinting() {
	FILE="${1:?need specify a file to remove noprinting characters!}"
	cat -v "$FILE" | sed -E 's~\^\[\[([[:digit:]]+;?)*m\^\[\[K~~g'
}

format-make-cyan() {
	STRING=${1:?need a string to format in cyan!}
	echo -e "${FORMAT_CYAN}${STRING}${FORMAT_RESET}"
}

# >>> pre statements!
if ! OPTIONS=`getopt -l "$GETOPT_LONG_OPTIONS" -n "$script" -- "$GETOPT_SHORT_OPTIONS" "$@"`; then
	print-exiting
elif ! [[ "$OPTIONS" =~ $REGEX_DEFAULT || "$OPTIONS" =~ $REGEX_REQUIRES ]]; then
	cat <<- EOF >&2
		$script: ${FORMAT_RED}missing required options${FORMAT_RESET}!
		$script: ${FORMAT_BOLD}-h${FORMAT_RESET} or ${FORMAT_BOLD}--help${FORMAT_RESET} to see!
	EOF
	print-exiting
fi
eval "set -- $OPTIONS"
while :; do
	OPTION="$1"
	ARGUMENT="$2"
	case $option in
		-m|--pattern) PATTERN="${ARGUMENT}"; shift 2;;
		-f|--pathway) PATHWAY="${ARGUMENT}"; shift 2;;
		-t|--typeof) TYPEOF="${ARGUMENT}"; shift 2;;
		-v|--version) print-version; exit 0;;
		-h|--help) print-usage; exit 0;;
		--) shift; break;;
		*) echo -e "${FORMAT_RED}script panic${FORMAT_RESET}!"; exit 1;;
	esac
done

# ***** PROGRAM START *****
cat <<- eof
	>>> $script!

	`format-make-cyan pattern`: ${PATTERN:?need a pattern to match!}
	`format-make-cyan pathway`: ${PATHWAY:?need a pathway to find!}
	`format-make-cyan typeof`: ${TYPEOF:?need a typeof to specify!}

	logfile: $LOG_FILE

eof
if [ "${TYPEOF,,}" = 'f' ] || [ "${TYPEOF,,}" = 'file' ]; then
	eval "grep --color=always -nFA 1 '$PATTERN' '${PATHWAY%/}'" | tee "$LOG_FILE" | less -R
	if ! iffnue; then
		for log_line in $(seq 2 3 `wc -l < "$LOG_FILE"`); do
			BLANK_LINE=`remove-nonprinting "$LOG_FILE" | tail -n +"$log_line" | head -1 | cut -d '-' -f 1`
			sed -i "$(("$BLANK_LINE"-"${count:-0}"))d" "$PATHWAY"
			let count++
		done
		print-leaving
	else
		print-leaving
	fi
elif [[ "${TYPEOF,,}" = 'd' || "${TYPEOF,,}" = 'directory' ]]; then
	eval "grep --color=always -nrIFA 1 '${PATTERN}' '${PATHWAY}/'" | tee "$LOG_FILE" | less -R
	if ! iffnue; then
		for file_and_line in `remove-nonprinting "$LOG_FILE" | grep --color=never -E '[[:digit:]]+-$' | sed -E 's/.$//'`; do
			ATUAL_FILE="${file_and_line%-*}"
			[ "$ATUAL_FILE" != "${PREVIOUS_FILE:-''}" ] && unset count
			sed -i "$(("${file_and_line##*-}"-"${count:-0}"))d" "$ATUAL_FILE"
			PREVIOUS_FILE="$ATUAL_FILE"
			let count++
		done
		print-leaving
	else
		print-leaving
	fi
else
	echo -e "$script: ${FORMAT_RED}incorrect${FORMAT_RESET} typeof argument!" >&2
	print-exiting
fi
