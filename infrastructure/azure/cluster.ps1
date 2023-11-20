param (
    [Parameter(Mandatory)] [string] $Environment,
    [Parameter(Mandatory)] [string] $Version
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

# create cluster in subnet
az aks create `
    --resource-group $resourceGroupName `
    --name $clusterName `
    --node-count 1 `
    --node-vm-size "Standard_B2s" `
    --network-plugin "kubenet" `
    --vnet-subnet-id $subnetId `
    --auto-upgrade-channel "stable" `
    --enable-managed-identity `
    --assign-identity $identityId `
    --assign-kubelet-identity $identityId `
    --attach-acr $containerRegistryName `
    --enable-oidc-issuer `
    --enable-workload-identity `
    --enable-cluster-autoscaler `
    --min-count 1 `
    --max-count 3 `
    --cluster-autoscaler-profile scan-interval=30s