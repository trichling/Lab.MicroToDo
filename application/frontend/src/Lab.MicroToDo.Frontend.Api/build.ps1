$prevPwd = $PWD; Set-Location -ErrorAction Stop -LiteralPath $PSScriptRoot

docker build -f Dockerfile -t thinkexception.azurecr.io/microtodo-frontendapi:dev .\..
docker push thinkexception.azurecr.io/microtodo-frontendapi:dev

$prevPwd | Set-Location
