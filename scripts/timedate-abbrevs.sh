#!/usr/bin/bash

# List timezones and your abbreviations.

# >>> built-in sets!
set +o histexpand

# >>> variables declaration!
readonly version='1.0.0'
readonly script="`basename "$0"`"

WIDER_TZ=`timedatectl list-timezones | wc -L`
CHARACTER=' '
SEPARATOR=':'

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Use timedatectl and date commands to list all time zones and yours abbreviations.

Usage: $script [<options>]

Options:
	-c <blank-char>: Change the blank character;
	-s <sep-char>: Change the separator character;
	-a <around-chars>: Sets the characters around abbreviation e.g. '()';
	-b: If abbreviation is null do not print around characters;
	-t: No tabs between timezone and abbreviation;
	-r <extended-regex>: Search a timezone ou abbreviation with regex;
	-v: Print version;
	-h: Print this help.
EOF
}

print-timezone() {
	TIMEZONE="${1:?needs the timezone to print}"
	if ! "$REMOVE_TABS"; then
		echo "$TIMEZONE"
	else
		echo "${TIMEZONE// }"
	fi
}

# >>> pre statements!
while getopts 'c:s:a:btr:vh' option; do
	case "$option" in
		c) CHARACTER="$OPTARG";;
		s) SEPARATOR="$OPTARG";;
		a)
			AROUND_LEFT="${OPTARG::1}"
			AROUND_RIGHT="${OPTARG: -1}"
		;;
		b) VALIDATE_AROUND='true';;
		t) REMOVE_TABS='true';;
		r) REGEX="$OPTARG";;
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
for timezone in `timedatectl list-timezones`; do
	ATUAL_SEPARATOR="$SEPARATOR"
	ATUAL_AROUND_LEFT="$AROUND_LEFT"
	ATUAL_AROUND_RIGHT="$AROUND_RIGHT"

	SPACE=`bc <<< "$WIDER_TZ-${#timezone}"`
	if "${REMOVE_TABS:=false}"; then SPACE='-1'; fi

	ABBREV=`env TZ="$timezone" date +'%Z'`
	if "${VALIDATE_AROUND:=false}"; then
		[ ! "$ABBREV" ] && unset ATUAL_AROUND_LEFT ATUAL_AROUND_RIGHT
	fi

	FULL_STRING="$timezone "
	FULL_STRING+="$(printf -- "`[ "$SPACE" -gt 0 ] && echo "$CHARACTER"`%.0s" `seq 1 "$SPACE"`)"
	FULL_STRING+="$ATUAL_SEPARATOR $ATUAL_AROUND_LEFT$ABBREV$ATUAL_AROUND_RIGHT"
	if [ "$REGEX" ]; then
		[[ "$timezone" =~ $REGEX ]] && print-timezone "$FULL_STRING"
		continue
	fi
	print-timezone "$FULL_STRING"
done
