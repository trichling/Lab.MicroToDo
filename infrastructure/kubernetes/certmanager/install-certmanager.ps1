param (
    [Parameter(Mandatory)] [string] $Environment,
    [Parameter(Mandatory)] [string] $Version
)

$prevPwd = $PWD; Set-Location -ErrorAction Stop -LiteralPath $PSScriptRoot

$location = "westeurope"
$application = "microtodo"
$resourceGroupName = "rg-$application-$Environment"
$clusterName = "aks-$application-$Environment-$Version"

az aks get-credentials -g $resourceGroupName -n $clusterName --overwrite-existing

kubectl create namespace cert-manager --dry-run=client -o yaml | kubectl apply -f -

helm repo add jetstack https://charts.jetstack.io
helm repo update

helm upgrade cert-manager jetstack/cert-manager --install `
    --namespace cert-manager `
    --set installCRDs=true

kubectl apply -k ./overlays/agic

$prevPwd | Set-Location