#!/usr/bin/env bash

yarn pack
yarn licenses generate-disclaimer > ThirdPartyLicenses.txt
NPM_CONFIG_USERCONFIG=/tmp/nonexistentrc

echo "$target_platform"
if [ "$target_platform" == "osx-arm64" ]; then
    export npm_config_arch="x64"
fi

target_platform
npm install -g ${PKG_NAME}-v${PKG_VERSION}.tgz
