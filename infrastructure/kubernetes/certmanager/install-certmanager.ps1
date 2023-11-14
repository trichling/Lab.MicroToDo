param (
    [Parameter(Mandatory)] [string] $Environment,
    [Parameter] [string] $Version
)

$prevPwd = $PWD; Set-Location -ErrorAction Stop -LiteralPath $PSScriptRoot

$location = "westeurope"
$application = "microtodo"
$resourceGroupName = "rg-$application-$Environment"
$clusterName = "aks-$application-$Environment-$Version"

az aks get-credentials -g $resourceGroupName -n $clusterName --overwrite-existing

kubectl create namespace cert-manager --dry-run=client -o yaml | kubectl apply -f -

helm repo add jetstack https://charts.jetstack.io

helm upgrade cert-manager jetstack/cert-manager --install `
    --namespace cert-manager `
    --set installCRDs=true

kubectl apply -f letsencrypt-prod-http-issuer.yaml
kubectl apply -f letsencrypt-staging-http-issuer.yaml

$prevPwd | Set-Location