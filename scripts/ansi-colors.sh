#!/usr/bin/bash

# Print ANSI colors.
#
# The "column" program is in the "bsdextrautils" package, install it if necessary.

# >>> built-in sets!
set +o histexpand

# >>> variables declaration!
readonly version='1.0.0'
readonly script="`basename "$0"`"

TEXT='ANSI'

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

ANSI colors (escape sequences) print.

Usage: $script [<options>]

Options:
	-t: Change text for test (default is 'ANSI');
	-c: Separate COLORS from EFFECTS table;
	-l: Split the two tables two lines;
	-s <separator>: Change manual table separator (default is '|');
	-v: Print version;
	-h: Print this help.
EOF
}

# >>> pre statements!
while getopts 't:cs:lvh' option; do
	case "$option" in
		t) TEXT="$OPTARG";;
		c) MANUAL_SEPARATOR='|  ';;
		s) MANUAL_SEPARATOR="$OPTARG  ";;
		l) FLAG_TWO_TABLES='true';;
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
RESET='\033[0m'
COLORS=(
	'Black'
	'Red'
	'Green'
	'Yellow'
	'Blue'
	'Magenta'
	'Cyan'
	'White'
)
TEXTS=(
	'FOREGROUND'
	'BRIGHT-FOREGROUND'
	'BACKGROUND'
	'BRIGHT-BACKGROUND'
)
declare -A TEXTS_MAP=(
	['FOREGROUND']='30'
	['BACKGROUND']='40'
	['BRIGHT-FOREGROUND']='90'
	['BRIGHT-BACKGROUND']='100'
)
EFFECTS=(
	'Bold'
	'Dim'
	'Italic'
	'Underline'
	'Blink'
	'Reverse'
	'Hide'
	'Strikethrough'
)
declare -A EFFECTS_MAP=(
	['Bold']='1'
	['Dim']='2'
	['Italic']='3'
	['Underline']='4'
	['Blink']='5'
	['Reverse']='7'
	['Hide']='8'
	['Strikethrough']='9'
)
for formatt in ${TEXTS[@]}; do
	for index in {0..7}; do
		CODE="$(("${TEXTS_MAP["$formatt"]}"+"$index"))"
		COLORS["$index"]+=":`echo -e "$CODE (\033[${CODE}m$TEXT$RESET)"`"
		[ "$formatt" = 'BRIGHT-BACKGROUND' ] && {
			if ! "${FLAG_TWO_TABLES:=false}"; then
				EFFECT="${EFFECTS["$index"]}"
				CODE="${EFFECTS_MAP["$EFFECT"]}"
				COLORS["$index"]+="`echo -e ":$MANUAL_SEPARATOR$EFFECT:$CODE:\033[${CODE}m$TEXT$RESET"`"$'\n'
			else
				COLORS["$index"]+=$'\n'
				CODE="${EFFECTS_MAP[${EFFECTS["$index"]}]}"
				EFFECTS["$index"]+="`echo -e " $CODE \033[${CODE}m$TEXT$RESET"`"$'\n'
			fi
		}
	done
done
echo -e "$script (ANSI Colors Print) v$version\n"
if ! "${FLAG_TWO_TABLES:=false}"; then
	column \
		-ts ':' \
	-N "COLORS,`tr ' ' ',' <<< "${TEXTS[*]}"`,${MANUAL_SEPARATOR}EFFECTS,CODE,EXAMPLE" \
	<<< "`sed -z 's/\n /\n/g' <<< "${COLORS[*]}"`"
else
	column \
		-ts ':' \
		-N "COLORS,`tr ' ' ',' <<< "${TEXTS[*]}"`" \
		<<< "`sed -z 's/\n /\n/g' <<< "${COLORS[*]}"`"
	echo
	column \
		-t \
		-N 'EFFECTS,CODE,EXAMPLE' \
		<<< "${EFFECTS[*]}"
fi
