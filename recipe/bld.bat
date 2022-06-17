@echo on
call yarn pack || goto :error
call yarn licenses generate-disclaimer > ThirdPartyLicenses.txt || goto :error

@echo on
where npm
call npm install --userconfig nonexistentrc --global %PKG_NAME%-v%PKG_VERSION%.tgz || goto :error

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%
