param (
    [Parameter(Mandatory)] [string] $Environment,
    [Parameter(Mandatory)] [string] $Version,
    [Parameter()] [string] $NetworkPlugin
)

# if no network plugin is provided, use kubenet
if (-not $NetworkPlugin) {
    $NetworkPlugin = "kubenet"
}

# define subnetAdressSpace depending on network plugin
if ($NetworkPlugin -eq "azure") {
    $subnetAddressSpace = "10.1.5.0/24"
} elseif ($NetworkPlugin -eq "kubenet") {
    $subnetAddressSpace = "10.1.5.0/28"
}

# define names
$application = "microtodo"
$resourceGroupName = "rg-$application-$Environment"
$containerRegistryName = "thinkexception"

$vnetName = "vnet-$application-$Environment"
$subnetName = "subnet-$application-$Environment-$Version"

$managedIdentityName = "identity-$application-$Environment-$Version"

$clusterName = "aks-$application-$Environment-$Version"

# create subnet for cluster in vnet
$clusterSubnetId = az network vnet subnet create `
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

# create cluster in subnet
az aks create `
    --resource-group $resourceGroupName `
    --name $clusterName `
    --node-count 1 `
    --node-vm-size "Standard_B2s" `
    --network-plugin "kubenet" `
    --vnet-subnet-id $clusterSubnetId `
    --auto-upgrade-channel "stable" `
    --enable-managed-identity `
    --assign-identity $identityId `
    --assign-kubelet-identity $identityId `
    --attach-acr $containerRegistryName