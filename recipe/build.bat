@echo on

md %LIBRARY_PREFIX%\share\prettier
pushd %LIBRARY_PREFIX%\share\prettier
md node_modules
cmd /c "npm install prettier@%PKG_VERSION%"
if errorlevel 1 exit 1
popd

pushd %LIBRARY_PREFIX%\bin
for %%c in (prettier) do (
  echo @echo off >> %%c.bat
  echo "%LIBRARY_PREFIX%\share\prettier\node_modules\.bin\%%c.cmd" %%* >> %%c.bat
)
popd

@rem remove '"packageManager": "yarn@<version>"' from package.json
jq "del(.packageManager)" package.json > package.json.new
if errorlevel 1 exit 1

copy package.json.new package.json
if errorlevel 1 exit 1

@rem port yarn.lock to pnpm-lock.yaml
cmd /c "pnpm import"
if errorlevel 1 exit 1

@rem install all (prod) dependencies, this needs to be done for pnpm to properly list all dependencies later on
cmd /c "pnpm install --prod"
if errorlevel 1 exit 1

@rem list all dependencies and then call pnpm-licenses to generate the ThirdPartyLicenses.txt file
cmd /c "pnpm licenses list --prod --json | pnpm-licenses generate-disclaimer --prod --json-input --output-file=ThirdPartyLicenses.txt"
if errorlevel 1 exit 1

@rem log directory structure in order to easily verify if porting yarn.lock, installing packages and generating licenses worked
dir
