del %PREFIX%\node.exe || goto :error
mklink %PREFIX%\node.exe %BUILD_PREFIX%\node.exe || goto :error

yarn pack || goto :error
yarn licenses generate-disclaimer > ThirdPartyLicenses.txt || goto :error
NPM_CONFIG_USERCONFIG=/tmp/nonexistentrc || goto :error

npm install -g %PKG_NAME%-v%PKG_VERSION%.tgz || goto :error

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%
