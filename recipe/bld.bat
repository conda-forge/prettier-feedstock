@echo on
cmd /c "yarn pack"
if errorlevel 1 exit 1
cmd /c "yarn licenses generate-disclaimer > ThirdPartyLicenses.txt"
if errorlevel 1 exit 1

md %LIBRARY_PREFIX%\share\prettier
pushd %LIBRARY_PREFIX%\share\prettier

md node_modules
cmd /c "npm install prettier@%PKG_VERSION%"
if errorlevel 1 exit 1

dir node_modules
dir node_modules\.bin
dir node_modules\prettier
dir node_modules\prettier\bin

pushd %LIBRARY_PREFIX%\bin
for %%c in (prettier) do (
  echo @echo on >> %%c.bat
  echo %LIBRARY_PREFIX%\share\prettier\node_modules\.bin\%%c.cmd "%%*" >> %%c.bat
)
