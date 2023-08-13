@echo on

md %LIBRARY_PREFIX%\share\prettier
pushd %LIBRARY_PREFIX%\share\prettier
md node_modules
cmd /c "npm install prettier@%PKG_VERSION%"
if errorlevel 1 exit 1
popd

pushd %LIBRARY_PREFIX%\bin
for %%c in (prettier) do (
  echo @echo on >> %%c.bat
  echo "%LIBRARY_PREFIX%\share\prettier\node_modules\.bin\%%c.cmd" %%* >> %%c.bat
)
popd

@rem port yarn.lock to pnpm-lock.yaml
npx pnpm@latest import

@rem install all (prod) dependencies, this needs to be done for pnpm to properly list all dependencies later on
npx pnpm@latest install --prod
if errorlevel 1 exit 1

@rem list all dependencies and then call pnpm-licenses to generate the ThirdPartyLicenses.txt file
npx pnpm@latest licenses list --prod --json | npx @quantco/pnpm-licenses generate-disclaimer --prod --json-input --output-file=ThirdPartyLicenses.txt
if errorlevel 1 exit 1
