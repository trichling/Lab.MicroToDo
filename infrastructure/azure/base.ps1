param (
    [Parameter(Mandatory)] [string] $Environment,
    [Parameter(Mandatory)] [string] $VnetAddressSpace
)

# if no vnet address space, use default
if (-not $VnetAddressSpace) {
    $VnetAddressSpace = "10.1.4.0/22"
}

# define names
$location = "westeurope"
$application = "microtodo"
$resourceGroupName = "rg-$application-$Environment"
$vnetName = "vnet-$application-$Environment"

# cerate ressource group
az group create `
    --name $resourceGroupName `
    --location $location

# create virtual network via az cli
az network vnet create `
    --resource-group $resourceGroupName `
    --location $location `
    --name $vnetName `
    --address-prefixes $VnetAddressSpace
