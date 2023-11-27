$prevPwd = $PWD; Set-Location -ErrorAction Stop -LiteralPath $PSScriptRoot

kubectl kustomize ./overlays/feature/agic
kubectl apply -k ./overlays/feature/agic

kubectl rollout restart deployment/microtodo-frontend

$prevPwd | Set-Location