#!/usr/bin/bash

# It does the entire push process automatically and if no parameter is passed, it commits with a standard message.

# >>> variable declaration!
readonly version='2.1.0'
script="`basename "$0"`"

# >>> function declaration!
usage() {
cat << EOF
$script v$version

Automatic run \`git add ./\` -> \`git commit -m "<message>"\` -> \`git push\`.
If \`<message>\` param is not passed use 'refresh' message as default.

For works fine, setup upstream linked branch with: \`git branch --set-upstream-to=<remote/branch>\`

Usage: $script [<options>] ['<message>']

Options:
	-v: Print version;
	-h: Print this help.
EOF
}

# >>> pre statements!
while getopts 'vh' OPTION; do
	case "$OPTION" in
		v) echo "$version"; exit 0;;
		:|?|h) usage; exit 2;;
	esac
done
shift $(("$OPTIND"-1))

# ***** PROGRAM START *****
git add ./
git commit -m "${1:-refresh}"
git push
