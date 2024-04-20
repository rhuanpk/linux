#!/usr/bin/bash

# It does the entire push process automatically and if no parameter is passed, it commits with a standard message.

# >>> variables declaration!
readonly version='2.2.0'
readonly script="`basename "$0"`"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Automatic run \`git add ./' -> \`git commit -m "<message>"' -> \`git push'.
If \`<message>' param is not passed use 'refresh' message as default.

The \`-n' option will use the remote defined as "origin".

For works fine, setup upstream linked branch with: \`git branch --set-upstream-to=<remote/branch>'

Usage: $script [<options>] [<message>]

Options:
	-n: When the push to a new branch;
	-v: Print version;
	-h: Print this help.
EOF
}

# >>> pre statements!
while getopts 'nvh' OPTION; do
	case "$OPTION" in
		n) flag_branch=true;;
		v) echo "$version"; exit 0;;
		h) usage; exit 1;;
		*) exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
message="${1:-wip}"
#remote="$(git remote -v | grep '(push)$' | awk '{print $2}')"
git add ./
git commit -m "$message"
if ! "${flag_branch:-false}"; then
	git push
else
	git push -u origin HEAD
fi
