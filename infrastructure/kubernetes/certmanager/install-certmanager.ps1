param (
    [Parameter(Mandatory)] [string] $Environment,
    [Parameter(Mandatory)] [string] $Version,
    [Parameter(Mandatory)] [string] $IngressController
)

# only nginx and agic are allowed as ingress controller
if ($IngressController -ne "nginx" -and $IngressController -ne "agic") {
    throw "IngressController $IngressController not supported"
}

$prevPwd = $PWD; Set-Location -ErrorAction Stop -LiteralPath $PSScriptRoot

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

kubectl apply -k ./overlays/$IngressController

$prevPwd | Set-Location