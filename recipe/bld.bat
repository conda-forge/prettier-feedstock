call yarn pack || goto :error
call yarn licenses generate-disclaimer > ThirdPartyLicenses.txt || goto :error

call npm config set prefix %BUILD_PREFIX% || goto :error
call npm install --userconfig nonexistentrc --global %PKG_NAME%-v%PKG_VERSION%.tgz || goto :error

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%
