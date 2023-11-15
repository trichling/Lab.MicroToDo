param (
    [Parameter(Mandatory)] [string] $Environment,
    [Parameter(Mandatory)] [string] $Version
)

$location = "westeurope"
$application = "microtodo"
$resourceGroupName = "rg-$application-$Environment"
$logAnalyticsWorkspaceName = "log-$application-$Environment"

az monitor log-analytics workspace create `
    --name $logAnalyticsWorkspaceName `
    --resource-group $resourceGroupName