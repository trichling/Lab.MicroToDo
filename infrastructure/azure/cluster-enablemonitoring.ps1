param (
    [Parameter(Mandatory)] [string] $Environment,
    [Parameter(Mandatory)] [string] $Version
)

$location = "westeurope"
$application = "microtodo"
$resourceGroupName = "rg-$application-$Environment"
$clusterName = "aks-$application-$Environment-$Version"
$logAnalyticsWorkspaceName = "log-$application-$Environment"

$logAnalyticsWorkspaceId = $(az monitor log-analytics workspace show --resource-group $resourceGroupName --workspace-name $logAnalyticsWorkspaceName --query id --output tsv)

az aks enable-addons -a monitoring `
    --resource-group $resourceGroupName `
    --name $clusterName `
    --workspace-resource-id $logAnalyticsWorkspaceId