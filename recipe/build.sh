#!/usr/bin/env bash

set -euxo pipefail

if [[ "${target_platform}" == "osx-arm64" ]]; then
    export npm_config_arch="arm64"
fi

yarn pack
yarn licenses generate-disclaimer > ThirdPartyLicenses.txt

npm config set prefix "${BUILD_PREFIX}"
npm install --global "${PKG_NAME}-v${PKG_VERSION}.tgz"
