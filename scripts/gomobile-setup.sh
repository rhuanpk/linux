#!/bin/bash

android_build_tools_version='34.0.0'
android_api_version='35'
gomobile_cmd='build'
gomobile_path='golang.org/x/mobile/example/basic'

url_cmdlinetool="$(curl -fsSL 'https://developer.android.com/studio' | sed -nE 's/^.*href="(.*commandlinetools-linux-.*_latest\.zip)"$/\1/p')"
path_tmp='/tmp'
path_cmdlinetool="$path_tmp/cmdline-tools"
file_cmdlinetool="$path_tmp/commandlinetools.zip"

while "${flag_menu:-true}"; do
	clear
	cat <<- EOF
		gomobile setup
		1) persistent
		2) temporary
		q) quit
	EOF
	read -p 'your choisse: '
	case "${REPLY,,}" in
		1) path_sdk="$HOME/Android/Sdk"; flag_menu=false;;
		2) path_sdk="$path_tmp/Android/Sdk"; flag_menu=false;;
		q) echo 'exit 0'; exit 0;;
		*) read -p 'wrong option <enter> ';;
	esac
done

read -p 'skip setup? (Y/n) '
[ -z "$REPLY" -o "${REPLY,,}" = 'y' ] && flag_setup='true'

read -p 'install instead build only? (y/N) '
[ "${REPLY,,}" = 'y' ] && gomobile_cmd='install'

read -ep "android build tools version: ($android_build_tools_version) "
[ "$REPLY" ] && android_build_tools_version="$REPLY"

read -ep "android api version: ($android_api_version) "
[ "$REPLY" ] && android_api_version="$REPLY"

read -ep "project path: ($gomobile_path) "
[ "$REPLY" ] && gomobile_path="$REPLY"

for folder in "$path_tmp" "$path_sdk"; do
	[ ! -d "$folder" ] && mkdir -pv "$folder"
done

for folder in "$path_tmp" "$path_sdk"; do
	[ ! -d "$folder" ] && mkdir -pv "$folder"
done

[ ! -f "$file_cmdlinetool" ] && {
	curl -fsSLo "$file_cmdlinetool" "$url_cmdlinetool"
	unzip -d "$path_tmp" "$file_cmdlinetool"
}

export ANDROID_BUILD_TOOLS_VERSION="$android_build_tools_version"
export ANDROID_API_VERSION="$android_api_version"
export ANDROID_HOME="$path_sdk"
export ANDROID_SDK_ROOT="$path_sdk"
export ANDROID_NDK_ROOT="$path_sdk/ndk-bundle"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export GO111MODULE='auto'

if ! "${flag_setup:-false}"; then
	yes | "$path_cmdlinetool"/bin/sdkmanager --sdk_root="$path_sdk" "build-tools;$ANDROID_BUILD_TOOLS_VERSION" 'cmdline-tools;latest' 'platform-tools' "platforms;android-$ANDROID_API_VERSION" 'ndk-bundle'
	gomobile init
	go get 'golang.org/x/mobile/cmd/gomobile' 'golang.org/x/mobile/example/basic'
fi
gomobile "$gomobile_cmd" -v -target=android -androidapi "$ANDROID_API_VERSION" "$gomobile_path"
