$prevPwd = $PWD; Set-Location -ErrorAction Stop -LiteralPath $PSScriptRoot

# dev build (with remote debugger)
docker build --target publish -f Dockerfile -t thinkexception.azurecr.io/microtodo-frontendapi:dev --build-arg CONFIG=Debug .\..
docker push thinkexception.azurecr.io/microtodo-frontendapi:dev

# production build (withou remote debugger)
docker build -f Dockerfile -t thinkexception.azurecr.io/microtodo-frontendapi:dev --build-arg CONFIG=Release .\..
docker push thinkexception.azurecr.io/microtodo-frontendapi:dev

$prevPwd | Set-Location
