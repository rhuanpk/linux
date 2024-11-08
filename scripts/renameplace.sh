#!/usr/bin/bash

# Advanced multi file renamer.

# >>> built-in sets!
set +o histexpand

# >>> variables declaration!
readonly version='2.2.0'
readonly script="`basename "$0"`"

FONT_BOLD=1
FONT_ITALIC=3
FONT_UNDERLINE=4
FONT_BLINK=5
FONT_REVERSE=7
COLOR_BLACK=30
COLOR_RED=31
COLOR_GREEN=32
COLOR_YELLOW=33
COLOR_BLUE=34
COLOR_MAGENTA=35
COLOR_CYAN=36
COLOR_WHITE=37
BACKGROUND_BLACK=40

LIST_ACCENTS=`
	cat <<- eof
		ÀÁÂÃÄÅÆ A
		ÈÉÊË E
		ÌÍÎÏ I
		ÒÓÔÕÖ O
		ÙÚÛÜ U
		Ç C
		àáâãäåæ a
		èéêë e
		ìíîï i
		òóôõö o
		ùúûü u
		ç c
	eof
`

LOG_FILE="/tmp/$script-`date +%y-%m-%d_%H:%M:%S`.log"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Advanced multiple file renamer.

Usage: $script [<options>]

Options:
	-v: Print version;
	-h: Print this help.
EOF
}

message-invalid-option() {
	echo -en "\nInvalid option! <press_enter> "; read
}

message-quit() {
	MAX_DOTS='3'
	clear; for ((i=0;i<3;i++)); do
		format "$FONT_BOLD" '\n\t*** THANK YOU ***\n'
		for ((j=0;j<="$MAX_DOTS";++j)); do
			[[ "$j" -eq '0' ]] && echo -en 'Exiting '
			sleep .1; echo -n '.'
			[[ "$j" -eq "$MAX_DOTS" ]] && clear
		done
	done
	echo "$script: log file: '$LOG_FILE'."
}

message-default-simply() {
	MESSAGE="${1:-need a message to print!}"
	cat <<- eof

		>> $MESSAGE!

		*** `format "$FONT_BOLD" 'Directory Listing'` ***

	eof
}


format() {
	FORMATTING="${1:-need a message to format!}"
	[[ "$FORMATTING" =~ ([[:digit:]]+;?)* ]] && MESSAGE="${@:2}" || MESSAGE="$*"
	echo -e "\e[${FORMATTING}m$MESSAGE\e[m"
}

list-directory() {
	ls --color=always -1hF
}

start-test-mode() {
	TMP_FOLDER='/tmp/tmp'
	echo -ne "\nCreate a safe folder for tests in \"/tmp/tmp/\", move to it and generate random files for tests! [Y/n] "; read ANSWER
	[ -z "$ANSWER" ] || [ y = "${ANSWER,,}" ] && {
		[ ! -d "$TMP_FOLDER/" ] && mkdir -pv "$TMP_FOLDER/"
		cd "$TMP_FOLDER/"
		touch ./file-{0..4}.{txt,tmp}
	}
}

submenu-blank-spaces() {

	switch-char-to-blank-space() {
		clear; echo
		list-directory
		echo -en "\nEnter the character to be removed, to insert the blank space(s) in its place: "; read STRING
		for file in *; do
			mv --verbose -- "$file" "${file//$STRING/ }" &>> "$LOG_FILE"
		done
	}

	switch-blank-space-to-char() {
		clear; echo
		list-directory; echo
		read -p 'Enter the character that will be placed in place of the blank space(s) (characters not accepted "<", ">", ":", "\", "/", "\", "|", "?", "*"): ' STRING
		for file in *; do
			mv --verbose -- "$file" "${file// /$STRING}" &>> "$LOG_FILE"
		done
	}

	while :; do
		clear
		message-default-simply 'Blank Spaces'
		list-directory
		cat <<- eof

			1. `format "$COLOR_YELLOW" 'Blank Spaces'` » `format "$COLOR_YELLOW;$FONT_BOLD" PUT`
			2. `format "$COLOR_YELLOW" 'Blank Spaces'` » `format "$COLOR_YELLOW;$FONT_BOLD" REMOVE`
			9. `format "$COLOR_BLUE" Back`
			0. `format "$COLOR_RED" EXIT`

		eof
		read -p 'Choice: ' OPTION
		case "$OPTION" in
			1) switch-char-to-blank-space;;
			2) switch-blank-space-to-char;;
			9) menu-main;;
			0) message-quit; exit 0;;
			*) message-invalid-option;;
		esac
	done

}

submenu-upper-lower() {

	to-upper() {
		clear
		for file in *; do
			mv --verbose -- "$file" "${file^^}" &>> "$LOG_FILE"
		done
	}

	to-lower() {
		clear
		for file in *; do
			mv --verbose -- "$file" "${file,,}" &>> "$LOG_FILE"
		done
	}

	while :; do
		clear
		message-default-simply 'Uppers and Lowercases'
		list-directory
		cat <<- eof

			1. `format "$COLOR_YELLOW" To` » `format "$COLOR_YELLOW;$FONT_BOLD" UPPERS`
			2. `format "$COLOR_YELLOW" To` » `format "$COLOR_YELLOW;$FONT_BOLD" lowers`
			9. `format "$COLOR_BLUE" Back`
			0. `format "$COLOR_RED" EXIT`

		eof
		read -p 'Choice: ' OPTION
		case "$OPTION" in
			1) to-upper;;
			2) to-lower;;
			9) menu-main;;
			0) message-quit; exit 0;;
			*) message-invalid-option;;
		esac
	done

}

remove-accents() {
	clear
	INDEX_SEQUENCE='0'
	INDEX_PARSE='1'
	for file in *; do
		while read -a accents; do
			if OUTPUT=`mv --verbose -- "$file" "${file//[${accents[$INDEX_SEQUENCE]}]/${accents[$INDEX_PARSE]}}" 2>&-`; then
				file=`sed -nE "s/^.*-> '(.*)'$/\1/p" <<< "$OUTPUT"`
			fi
			echo "$OUTPUT" &>> "$LOG_FILE"
		done <<< $LIST_ACCENTS
	done
}

submenu-file-names() {

	message-default-composed() {
		MESSAGE="${1:-need a message to print!}"
		cat <<- eof

			>> $MESSAGE!

			- To go back to the previous menu whithout doing anything: <pess_enter> (double press if needed).

			*** `format "$FONT_BOLD" 'Directory Listing'` ***

		eof
	}

	message-input() {
		MESSAGE="${1:-need a message to print!}"
		echo -en "\nEnter the `format "$COLOR_YELLOW;$FONT_BOLD" "$MESSAGE"` of each file name: "
	}

	add-string-to-end() {
		clear
		message-default-composed 'Add/Remove from Begin/End'
		list-directory
		message-input 'string to be added to the end'
		read STRING
		for file in *; do
			mv --verbose -- "$file" "${file//*/$file$STRING}" &>> "$LOG_FILE"
		done
	}

	remove-string-to-end() {
		clear
		message-default-composed 'Add/Remove from Begin/End'
		list-directory
		message-input 'string to be removed to the end'
		read STRING
		for file in *; do
			mv --verbose -- "$file" "${file%%$STRING}" &>> "$LOG_FILE"
		done
	}

	add-string-to-begin() {
		clear
		message-default-composed 'Add/Remove from Begin/End'
		list-directory
		message-input 'string to be added to the begin'
		read STRING
		for file in *; do
			mv --verbose -- "$file" "$STRING$file" &>> "$LOG_FILE"
		done
	}

	remove-string-to-begin() {
		clear
		message-default-composed 'Add/Remove from Begin/End'
		list-directory
		message-input 'string to be removed to the begin'
		read STRING
		for file in *; do
			mv --verbose -- "$file" "${file##$STRING}" &>> "$LOG_FILE"
		done
	}

	rename-middle() {
		clear
		message-default-composed 'Rename specific string'
		list-directory
		echo -e "\nRename all files changing one part of the string to another!\n"
		read -p 'Input string: ' INPUT
		read -p 'String de saida: ' OUTPUT
		[ -z "$INPUT" ] && [ -z "$OUTPUT" ] && {
			echo -en "\nGo backing to the previous menu whithout doing anything... <press_enter> "; read
			submenu-file-names
		}
		for file in *; do
			mv --verbose -- "$file" "${file//$INPUT/$OUTPUT}" &>> "$LOG_FILE"
		done
	}

	create-pattern() {
		clear
		cat <<- eof

			>>> Create patterning!

			If you continue, the program will rename all files in the current directory
			for a name pattern, using numeric characters ([0-9]) as string characters.

			Example:

			*_0.any
			*_1.any
			*_2.any
			*_3.any
			*_4.any

			...

			- To return to the previous menu type: `format "$COLOR_MAGENTA" quit`

			*** `format "$FONT_BOLD" 'Directory Listing'` ***

		eof
		list-directory; echo
		echo -ne "Enter the file extension (`format "$FONT_ITALIC" empty` for no extension or \"`format "$COLOR_CYAN" =`\" for same extension): "; read EXTENSION
		[ "$EXTENSION" != 'quit' ] && {
			count=0
			for file in *; do
				mv --verbose -- "$file" "_$count${EXTENSION/=/.${file##*.}}" &>> "$LOG_FILE"
				let count++
			done
		}
	}

	custom-mode() {
		get-name() {
			echo "`ls -1 | sed -n "${1}p"`"
		}
		COUNT_LINES="`ls -1 | wc -l`"
		for index in `seq "$COUNT_LINES"`; do
			FILE_NAMES["$index"]=`get-name "$index"`
		done
		let COUNT_LINES++
		for i in `seq "$COUNT_LINES"`; do
			clear; cat <<-eof

				>>> Custom Rename!

				- To not rename any file just: <press_enter>
				- To stop and go back to the previous menu type: `format "$COLOR_MAGENTA" quit`

			eof
			for ((j=1;j<"$COUNT_LINES";j++)); do
				[ "${FILE_NAMES[$i]}" = "`get-name $j`" ] && format "$BACKGROUND_BLACK;$COLOR_YELLOW;$FONT_BOLD" "`get-name "$j"`" || get-name "$j"
			done
			if [ "$i" -lt "$COUNT_LINES" ]; then
				echo; read -rep "Entre com o novo nome do arquivo \"${FILE_NAMES[$i]}\": " -i "${FILE_NAMES[$i]}" NEW_NAME
				[ "$NEW_NAME" = 'quit' ] && break
				mv -v -- "${FILE_NAMES[$i]}" "$NEW_NAME" &>> "$LOG_FILE"
			fi
		done; echo
	}

	function thirdmenu-rename() {
		while :; do
			clear
			message-default-simply 'Add/Remove from Begin/End'
			list-directory
			cat <<- eof

				1. `format "$COLOR_GREEN" Add` some string on `format "$COLOR_YELLOW" begin` file name.
				2. `format "$COLOR_MAGENTA" Remove` some string on `format "$COLOR_YELLOW" begin` file name.
				3. `format "$COLOR_GREEN" Add` some string on `format "$COLOR_YELLOW" end` file name.
				4. `format "$COLOR_MAGENTA" Remove` some string on `format "$COLOR_YELLOW" end` file name.
				9. `format "$COLOR_BLUE" Back`
				0. `format "$COLOR_RED" EXIT`

			eof
			read -p 'Choice: ' OPTION
			case "$OPTION" in
				1) add-string-to-begin;;
				2) remove-string-to-begin;;
				3) add-string-to-end;;
				4) remove-string-to-end;;
				9) submenu-file-names;;
				0) message-quit; exit 0;;
				*) message-invalid-option;;
			esac
		done
	}

	while :; do
		clear
		message-default-simply 'File Manipulation'
		list-directory
		cat <<- eof

			1. `format "$COLOR_YELLOW" Add/Remove` String on `format "$COLOR_YELLOW" Begin/End` in File
			2. `format "$COLOR_YELLOW" 'Rename Part'` of Name
			3. Create `format "$COLOR_YELLOW" 'Pattern Name'`
			4. `format "$COLOR_YELLOW" 'Custom Rename'` Fully
			9. `format "$COLOR_BLUE" Back`
			0. `format "$COLOR_RED" EXIT`

		eof
		read -p 'Choice: ' OPTION
		case $OPTION in
			1) thirdmenu-rename;;
			2) rename-middle;;
			3) create-pattern;;
			4) custom-mode;;
			9) menu-main;;
			0) message-quit; exit 0;;
			*) message-invalid-option;;
		esac
	done

}

menu-main() {
	while :; do
		clear
		cat <<- eof

			>>> `format "$FONT_BOLD" RenamePlace`!

			Choose the renaming options!
			1. Add/Remove `format "$COLOR_YELLOW" 'BLANK SPACES'`
			2. Switch `format "$COLOR_YELLOW" 'UPPER and LOWER'`
			3. `format "$COLOR_YELLOW" 'REMOVE ACCENTS'` from Letters
			4. Manipulate `format "$COLOR_YELLOW" 'FILE NAMES'`
			5. `format "$COLOR_YELLOW" 'Start Env'` (test mode)
			6. `format "$COLOR_BLUE" 'List Current Directory'`
			0. `format "$COLOR_RED" EXIT`

		eof
		read -p 'Choice: ' OPTION
		case "$OPTION" in
			1) submenu-blank-spaces;;
			2) submenu-upper-lower;;
			3) remove-accents;;
			4) submenu-file-names;;
			5) start-test-mode;;
			6)
				echo; list-directory
				echo -en "\n<press_enter> "; read zkt
			;;
			0) message-quit; exit 0;;
			*) message-invalid-option;;
		esac
	done
}

# >>> pre statements!
while getopts 'vh' option; do
	case "$option" in
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
menu-main
