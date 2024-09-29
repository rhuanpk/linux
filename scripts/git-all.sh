#!/usr/bin/bash

# Script that uploads all repositories automatically.
# Requirements:
# 	1. Have credential.helper enabled.
# The variable "_REPO_PATHS" must receive the path of the directory where all repos are located.

# >>> built-in sets!
set +o histexpand

# >>> variables declaration!
readonly version='2.3.1'
readonly script="`basename "$0"`"

FILE_PATH=~/.config/git-all.path
#_REPO_PATHS='/tmp'
FLAG_CUSTOM='false'
FLAG_PULL='false'
FLAG_ERROR='false'

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

`formatter 1 DESCRIPTION`

`formatter 1 Normal Mode`:
	Pass the git command to be used as a parameter, if no parameters are passed it will push by default.
	The parameter can be passed without double quotes.

	In this usage mode, neither the confirmation message nor the branch can be defined.
	By default it confirms with the message "wip" in the master branch.

`formatter 1 Custom Mode`:
	At each iteration of the loop you can set the message and branch of the current repository.
	This mode only accepts git push.

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
	`formatter 1 -p \<path\>`: Set a temporary path (that's valid only this time) to grab the folders;
	`formatter 1 -v`: Print version;
	`formatter 1 -h`: Print this message and exit with 2.

`formatter 1 OBSERVATIONS`
	- For some features works is necessary to setup \`--set-upstream-to\` with: git branch --set-upstream-to=<remote/branch>
	- If passing some command you can use the \`:repo:\` replacement e.g.: $script git remote set-url origin 'git@remote.any:user/:repo:.git'
EOF
}

formatter() {
	formatting="$1"
	[[ "$formatting" =~ ([[:digit:]]+;?)* ]] && message="${@:2}" || message="$*"
	echo -e "\e[${formatting}m$message\e[m"
}

get-path() {
	{ echo "$(< "$FILE_PATH")"; } 2>&-
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
		if echo "${path/%\//}" >"$FILE_PATH"; then
			echo -e "`formatter 32 '> New path successfully changed!'`"
		else
			echo -e "`formatter 31 '> New path NOT successfully changed!'`"
		fi
	fi
}


# >>> pre statements!
while getopts 'lscgep:vh' OPTION; do
	case "$OPTION" in
		l) print-path; exit 0;;
		s) switch-path; exit 0;;
		c) FLAG_CUSTOM=true;;
		g) FLAG_PULL=true;;
		e) FLAG_ERROR=true;;
		p) _REPO_PATHS="$OPTARG";;
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

[ ! -f "$FILE_PATH" ] || [ ! -s "$FILE_PATH" ] && {
	echo -e "$script: error: file path is not exists or set ups, use \`-s\` flag"
	exit 1
}

# ***** PROGRAM START *****
[ -z "$_REPO_PATHS" ] && _REPO_PATHS="`get-path`"
COUNT="$(ls -1d `realpath "$_REPO_PATHS"`/* | wc -l)"
for directory in "`realpath "$_REPO_PATHS"`"/*; do
	repo="`basename $directory`"
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
