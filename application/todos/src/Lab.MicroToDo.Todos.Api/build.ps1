$prevPwd = $PWD; Set-Location -ErrorAction Stop -LiteralPath $PSScriptRoot

docker build -f Dockerfile -t thinkexception.azurecr.io/microtodo-todosapi:dev .\..
docker push thinkexception.azurecr.io/microtodo-todosapi:dev

$prevPwd | Set-Location
