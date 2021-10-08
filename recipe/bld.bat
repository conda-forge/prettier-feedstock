del %PREFIX%/bin/node
mklink %BUILD_PREFIX%/bin/node %PREFIX%/bin/node

yarn pack
yarn licenses generate-disclaimer > ThirdPartyLicenses.txt
NPM_CONFIG_USERCONFIG=/tmp/nonexistentrc

npm install -g %PKG_NAME%-v%PKG_VERSION%.tgz
