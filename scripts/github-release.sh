#!/usr/bin/bash

# Get links of latest release the archives from github.

# >>> variables declaration!
readonly version='1.0.0'
readonly script="`basename "$0"`"

# >>> functions declaration!
usage() {
cat << EOF
$script v$version

Returns all URL's of assets the latest GitHub release.

Usage: $script [<options>] 'user/repo'

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
USER_AND_REPO=${1:?needs a user and repo to search!}
curl -sSL "https://api.github.com/repos/$USER_AND_REPO/releases/latest" \
	| sed -nE 's/.*"browser_download_url": "(.*)".*/\1/p'
