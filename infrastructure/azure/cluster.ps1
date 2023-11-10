param (
    [Parameter(Mandatory)] [string] $Environment,
    [Parameter] [string] $Version
)

# define names
$location = "westeurope"
$application = "microtodo"
$resourceGroupName = "rg-$application-$Environment"
$containerRegistryName = "thinkexception"

$vnetName = "vnet-$application-$Environment"
$subnetName = "subnet-$application-$Environment-$Version"
$subnetAddressSpace = "10.1.5.0/28"

$managedIdentityName = "identity-$application-$Environment-$Version"

$clusterName = "aks-$application-$Environment-$Version"

# create subnet for cluster in vnet
$vnetId = az network vnet show `
    --resource-group $resourceGroupName `
    --name $vnetName `
    --query id -o tsv

$subnetId = az network vnet subnet create `
    --resource-group $resourceGroupName `
    --vnet-name $vnetName `
    --name $subnetName `
    --address-prefixes $subnetAddressSpace `
    --query id -o tsv

# create identity for the cluster
$identityId = az identity create `
    --resource-group $resourceGroupName `
    --name $managedIdentityName `
    --query id -o tsv

# create acr pull role assignemnt for identity
# $containerRegistryId = az acr show `
#     --resource-group "Infrastructure" `
#     --name $containerRegistryName `
#     --query id -o tsv

# az role assignment create `
#     --assignee $identityId `
#     --role "AcrPull" `
#     --scope $containerRegistryId

# create cluster in subnet
az aks create `
    --resource-group $resourceGroupName `
    --name $clusterName `
    --node-count 1 `
    --node-vm-size "Standard_B2s" `
    --network-plugin "kubenet" `
    --vnet-subnet-id $subnetId `
    --enable-managed-identity `
    --assign-identity $identityId `
    --attach-acr $containerRegistryName