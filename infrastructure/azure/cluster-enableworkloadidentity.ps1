param (
    [Parameter(Mandatory)] [string] $Environment,
    [Parameter(Mandatory)] [string] $Version
)

# define names
$application = "microtodo"
$resourceGroupName = "rg-$application-$Environment"
$clusterName = "aks-$application-$Environment-$Version"

az aks update `
    --resource-group $resourceGroupName `
    --name $clusterName  `
    --enable-oidc-issuer `
    --enable-workload-identity



