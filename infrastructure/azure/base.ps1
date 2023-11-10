param (
    [Parameter(Mandatory)] [string] $Environment
)

# define names
$location = "westeurope"
$application = "microtodo"
$resourceGroupName = "rg-$application-$Environment"
$vnetName = "vnet-$application-$Environment"
$vnetAddressSpace = "10.1.4.0/22"

# cerate ressource group
az group create `
    --name $resourceGroupName `
    --location $location

# create virtual network via az cli
az network vnet create `
    --resource-group $resourceGroupName `
    --location $location `
    --name $vnetName `
    --address-prefixes $vnetAddressSpace
