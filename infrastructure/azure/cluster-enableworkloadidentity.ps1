param (
    [Parameter(Mandatory)] [string] $Environment,
    [Parameter(Mandatory)] [string] $Version
)

# define names
$location = "westeurope"
$application = "microtodo"
$resourceGroupName = "rg-$application-$Environment"
$containerRegistryName = "thinkexception"
$managedIdentityName = "identity-$application-$Environment-$Version"
$federatedIdentityName = "federatedidentity-$application-$Environment-$Version"
$clusterName = "aks-$application-$Environment-$Version"

az aks update `
    --resource-group $resourceGroupName `
    --name $clusterName  `
    --enable-oidc-issuer `
    --enable-workload-identity



