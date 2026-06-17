#!/usr/bin/bash

# >>> built-in sets!
set +o histexpand

# >>> variables declaration!
readonly version='2.7.0'
readonly script="$(basename "$0")"

FLAG_CUSTOM='false'
FLAG_PULL='false'
FLAG_ERROR='false'
PATH_FILE=~/.config/git-all.path
#PATH_REPOS='/tmp'

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

`formatter 1 DESCRIPTION`

`formatter 4 NORMAL_MODE`:
	Pass the git command to be used as a parameter, if no parameters are passed it will \`git status' by default.
	The parameter can be passed without quotes.

`formatter 4 CUSTOM_MODE`:
	At each iteration of the loop you can set the message and branch of the current repository.
	In this mode the uniq operation to perform is \`git push'.

`formatter 1 USAGE`

Usage passing parameters:
	$script [<options>] `formatter 33 git status`

	OR

	$script [<options>] `formatter 33 '"git pull origin master"'`

Usage without passing parameters:
	$script [<options>]

`formatter 1 OPTIONS`
	`formatter 1 -l`: List the atual path selected and exit 0
	`formatter 1 -s`: Set a new path to grab the folders
	`formatter 1 -c`: Start the `formatter 4 CUSTOM_MODE`
	`formatter 1 -g`: Pull in all repos
	`formatter 1 -e`: Show errors when enter in repo (if occurs)
	`formatter 1 -p \"\<path\>\"`: Set path once to grab the folders
	`formatter 1 -r \"\<repo\>\[,\<repo\>\...]\"`: Set repos (comma separated) inside path to iterate over
	`formatter 1 -v`: Print version
	`formatter 1 -h`: Print this message and exit 2

`formatter 1 OBSERVATIONS`
	- Pass a "!" in the begin of \`-r' flag to invert match
	- For some features works is necessary to setup \`--set-upstream-to' with: git branch --set-upstream-to=<remote/branch>
	- If passing some command you can use the internal \`:repo:' replacement, where the replacement is present will be
		changed to the name of the atual repo e.g.: $script git remote set-url origin 'git@remote.any:user/:repo:.git'

EOF
}

formatter() {
	formatting="$1"
	[[ "$formatting" =~ ([[:digit:]]+;?)* ]] && message="${@:2}" || message="$*"
	echo -e "\e[${formatting}m$message\e[m"
}

get-path() {
	{ echo "$(< "$PATH_FILE")"; } 2>&-
}

print-path() {
	git_path="$(get-path)"
	[ "$git_path" ] \
		&& message="\"`formatter 33 "$git_path"`\"" \
		|| message="`formatter 31 none path sets`"
	cat <<- eof
		Atual path: $message!
	eof
}

switch-path() {
	atual_path="$(print-path)"
	[ "$(sed -nE 's/^.*\x1b\[([0-9]+;?)+m(.*)\x1b\[.*$/\2/p' <<< "$atual_path")" ] && echo "$atual_path"
	read -ep "Enter the new path where the repositories are: " path
	path="${path/#~/$HOME}"
	if [ -z "$path" ]; then
		echo "`formatter 31 '> The path can not is null!'`"
		exit 1
	elif [ ! -d "$path" ]; then
		echo "`formatter 31 '> The path not exist!'`"
		exit 1
	else
		if echo "${path/%\/}" >"$PATH_FILE"; then
			echo "`formatter 32 '> New path successfully changed!'`"
		else
			echo "`formatter 31 '> New path NOT successfully changed!'`"
		fi
	fi
}


# >>> pre statements!
while getopts 'lscgep:r:vh' OPTION; do
	case "$OPTION" in
		# checks
		#p) [[ "$OPTARG" =~ ^- ]] && { #[ "${OPTARG:0:1}" = - ]
		#	echo "$script: `formatter 2\;31 ERR`: path can't contains '-' as first char in \`-p' flag" >&2
		#	exit 2
		#};;&
		# cases
		l) print-path; exit 0;;
		s) switch-path; exit 0;;
		c) FLAG_CUSTOM=true;;
		g) FLAG_PULL=true;;
		e) FLAG_ERROR=true;;
		p) PATH_REPOS="$OPTARG";;
		r) NAME_REPOS="$OPTARG";;
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $((OPTIND - 1))

[ ! -f "$PATH_FILE" ] || [ ! -s "$PATH_FILE" ] && {
	echo "$script: `formatter 2\;31 ERR`: file path is not exists or is set, use \`-s' flag" >&2
	exit 2
}

[[ "$PATH_REPOS" && ! -d "$PATH_REPOS" ]] && {
	echo "$script: `formatter 2\;31 ERR`: repos path is not valid or found: '$PATH_REPOS'" >&2
	exit 2
}

PATH_REPOS="${PATH_REPOS:+$(realpath -- "$PATH_REPOS")}"

[[ "$PATH_REPOS" && "$(find "$PATH_REPOS" -maxdepth 0 -empty)" ]] && {
	echo "$script: `formatter 2 INFO`: repos path is empty: '$PATH_REPOS'"
	exit 0
}

# ***** PROGRAM START *****
[ -z "$PATH_REPOS" ] && PATH_REPOS="$(get-path)"
ARRAY_REPOS=("$PATH_REPOS"/*)
[[ "$NAME_REPOS" && ! "$NAME_REPOS" =~ ^! ]] && {
	unset ARRAY_REPOS
	IFS=',' read -ra NAME_REPOS <<< "$NAME_REPOS"
	for repo in "${NAME_REPOS[@]}"; do
		ARRAY_REPOS+=("$PATH_REPOS/$repo")
	done
}
COUNT="${#ARRAY_REPOS[@]}"
CHARS="$(printf -- '-%.0s' $(seq 42); echo)"
for directory in "${ARRAY_REPOS[@]}"; do
	repo="$(basename "$directory")"
	[[ "$NAME_REPOS" && "$NAME_REPOS" =~ ^! ]] && {
		[[ "$NAME_REPOS" =~ $repo ]] && continue
	}
	if ! OUTPUT=$(cd "$directory" 2>&1); then
		if "$FLAG_ERROR"; then
			directory="`formatter 1 "$directory"`"
			{
				[[ "$OUTPUT" =~ [nN]ot\ a\ directory ]] \
				&& echo "$script: `formatter 2\;33 WARN`: \"$directory\" is not a folder" >&2
			} || {
				[[ "$OUTPUT" =~ [pP]ermission\ denied ]] \
				&& echo "$script: `formatter 2\;33 WARN`: \"$directory\" don't has permission" >&2
			} || \
				echo "$script: `formatter 2\;31 ERR`: $OUTPUT \"$directory\"" >&2
			FLAG_SEPARATOR='true'
		else
			FLAG_SEPARATOR='false'
		fi
	else
		cd "$directory" 2>&1
		echo -e "${SEPARATOR}→ git in *`formatter 1 "${repo^^}"`*!\n"
		if "$FLAG_CUSTOM"; then
			read -rp 'Edit this repository? (y)es/(n)ext: ' answer
			[ "${answer,,}" = 'n' ] 2>&- && continue
			read -rp "Enter with the message (wip): " GIT_MESSAGE; echo
			git add ./
			git commit -m "${GIT_MESSAGE:-wip}"
			git push
		elif "$FLAG_PULL"; then
			git pull
		else
			[ "$#" -eq 0 ] && git status || eval ${*//:repo:/$repo}
		fi
		FLAG_SEPARATOR='true'
	fi
	if "$FLAG_SEPARATOR"; then
		((COUNT > 1)) && SEPARATOR="`formatter 34 "$CHARS"`\n"
	fi
	let COUNT--
done
