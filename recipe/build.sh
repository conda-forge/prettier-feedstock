#!/usr/bin/env bash

set -euxo pipefail
if [[ "${target_platform}" == "osx-arm64" ]]; then
    export npm_config_arch="arm64"
fi

rm $PREFIX/bin/node
ln -s $BUILD_PREFIX/bin/node $PREFIX/bin/node

pnpm install
pnpm licenses list --json | pnpm-licenses generate-disclaimer --json-input > ThirdPartyLicenses.txt

pnpm pack
NPM_CONFIG_USERCONFIG=/tmp/nonexistentrc
npm install -g ${PKG_NAME}-${PKG_VERSION}.tgz
