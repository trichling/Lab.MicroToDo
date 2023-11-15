$prevPwd = $PWD; Set-Location -ErrorAction Stop -LiteralPath $PSScriptRoot

docker build -f Dockerfile -t thinkexception.azurecr.io/container-stress:latest .
docker push thinkexception.azurecr.io/container-stress:latest

$prevPwd | Set-Location
