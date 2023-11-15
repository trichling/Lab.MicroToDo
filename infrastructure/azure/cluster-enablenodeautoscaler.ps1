param (
    [Parameter(Mandatory)] [string] $Environment,
    [Parameter(Mandatory)] [string] $Version
)

# https://learn.microsoft.com/en-us/azure/aks/cluster-autoscaler?tabs=azure-cli#use-the-cluster-autoscaler-with-node-pools

$location = "westeurope"
$application = "microtodo"
$resourceGroupName = "rg-$application-$Environment"
$clusterName = "aks-$application-$Environment-$Version"

az aks update `
    --resource-group $resourceGroupName `
    --name $clusterName  `
    --enable-cluster-autoscaler `
    --min-count 1 `
    --max-count 3 `
    --cluster-autoscaler-profile scan-interval=30s