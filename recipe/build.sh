#!/usr/bin/env bash

set -euxo pipefail

if [[ "${target_platform}" == "osx-arm64" ]]; then
    export npm_config_arch="arm64"
fi

# Don't use pre-built gyp packages
export npm_config_build_from_source=true

rm $PREFIX/bin/node
ln -s $BUILD_PREFIX/bin/node $PREFIX/bin/node

# Ignore any global/user npm & pnpm configuration on the CI host (e.g. a
# minimum-release-age policy) that can make `pnpm import` crash. These must be
# exported so the child npm/pnpm processes actually pick them up, and the user
# and global config paths must differ (npm refuses to load the same file twice).
export NPM_CONFIG_USERCONFIG=/tmp/nonexistent-userrc
export NPM_CONFIG_GLOBALCONFIG=/tmp/nonexistent-globalrc
# Explicitly disable the resolution minimum-release-age policy which triggers
# ERR_PNPM_RESOLUTION_POLICY_VIOLATIONS_UNHANDLED on some pnpm versions.
export npm_config_minimum_release_age=0

# install prettier globally from the npm registry
# all things coming after this are just concerned with generating the ThirdPartyLicenses.txt file
npm install -g ${PKG_NAME}@${PKG_VERSION}

# Let us use pnpm for licenses
cat <<< $(jq 'del(.packageManager)' package.json) > package.json

pnpm import
pnpm install --prod
pnpm licenses list --json --prod | pnpm-licenses generate-disclaimer --json-input --output-file=ThirdPartyLicenses.txt
