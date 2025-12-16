#!/usr/bin/bash

# >>> built-in sets!
set +o histexpand

# >>> variables declaration!
readonly version='2.4.0'
readonly script="`basename "$0"`"

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

Normal mode:
	Pass the git command to be used as a parameter, if no parameters are passed it will \`git status' by default.
	The parameter can be passed without quotes.

Custom mode:
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
	`formatter 1 -l`: List the atual path selected and exit with 0;
	`formatter 1 -s`: Set a new path to grab the folders;
	`formatter 1 -c`: Start the CUSTOM MODE;
	`formatter 1 -g`: Pull in all repos;
	`formatter 1 -e`: Show errors on cd in repo if occurs;
	`formatter 1 -p \<path\>`: Set path once to grab the folders;
	`formatter 1 -p \<repo\>\[, \<repo sitory\>\]`: Set repos (comma separated) inside path to iterate over;
	`formatter 1 -v`: Print version;
	`formatter 1 -h`: Print this message and exit with 2.

`formatter 1 OBSERVATIONS`
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
	git_path="`get-path`"
	[ "$git_path" ] \
		&& message="\"$(formatter 33 "$git_path")\"" \
		|| message="$(formatter 31 none path sets)"
	cat <<- eof
		Atual path: $message!
	eof
}

switch-path() {
	atual_path="`print-path`"
	[ "$(sed -nE 's/^.*\x1b\[([0-9]+;?)+m(.*)\x1b\[.*$/\2/p' <<< "$atual_path")" ] && echo -e "$atual_path"
	read -ep "Enter the new path where the repositories are: " path
	path="${path/#~/$HOME}"
	if [ -z "$path" ]; then
		echo -e "`formatter 31 '> The path can not is null!'`"
		exit 1
	elif [ ! -d "$path" ]; then
		echo -e "`formatter 31 '> The path not exist!'`"
		exit 1
	else
		if echo "${path/%\//}" >"$PATH_FILE"; then
			echo -e "`formatter 32 '> New path successfully changed!'`"
		else
			echo -e "`formatter 31 '> New path NOT successfully changed!'`"
		fi
	fi
}


# >>> pre statements!
while getopts 'lscgep:r:vh' OPTION; do
	case "$OPTION" in
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
shift $(("$OPTIND"-1))

[ ! -f "$PATH_FILE" ] || [ ! -s "$PATH_FILE" ] && {
	echo -e "$script: error: file path is not exists or set ups, use \`-s\` flag"
	exit 1
}

# ***** PROGRAM START *****
[ -z "$PATH_REPOS" ] && PATH_REPOS="`get-path`"
ARRAY_REPOS=("`realpath "$PATH_REPOS"`"/*)
[ "$NAME_REPOS" ] && {
	unset ARRAY_REPOS
	IFS=',' read -ra NAME_REPOS <<< "$NAME_REPOS"
	for repo in "${NAME_REPOS[@]}"; do
		ARRAY_REPOS+=("$PATH_REPOS/$repo")
	done
}
COUNT="${#ARRAY_REPOS[@]}"
for directory in "${ARRAY_REPOS[@]}"; do
	repo="`basename "$directory"`"
	if ! OUTPUT=`cd "$directory" 2>&1`; then
		if "$FLAG_ERROR"; then
			directory="`formatter 1 "$directory"`"
			{
				[[ "$OUTPUT" =~ [nN]ot\ a\ directory ]] \
				&& echo -e "$script: warning: \"$directory\" is not a folder"
			} || {
				[[ "$OUTPUT" =~ [pP]ermission\ denied ]] \
				&& echo -e "$script: warning: \"$directory\" don't has permission";
			} || \
				echo -e "$script: warning: some wrong occurred on entering in \"$directory\""
			FLAG_SEPARATOR='true'
		else
			FLAG_SEPARATOR='false'
		fi
	else
		cd "$directory" 2>&1
		echo -e "${SEPARATOR}→ git in *$(formatter 1 "${repo^^}")*!\n"
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
		((COUNT>1)) &&  SEPARATOR="$(formatter 34 "$(printf -- '-%.0s' `seq 42`; echo)")\n"
	fi
	let COUNT--
done
