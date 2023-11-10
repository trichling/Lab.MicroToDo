$prevPwd = $PWD; Set-Location -ErrorAction Stop -LiteralPath $PSScriptRoot

docker build -f Dockerfile -t thinkexception.azurecr.io/microtodo-frontend:dev .\..
docker push thinkexception.azurecr.io/microtodo-frontend:dev

$prevPwd | Set-Location
