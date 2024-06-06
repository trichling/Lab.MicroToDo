param (
    [Parameter(Mandatory)] [string] $Environment,
    [Parameter(Mandatory)] [string] $Version,
    [Parameter(Mandatory)] [string] $VnetStartIp,
    [Parameter()] [string] $NetworkPlugin
)

#region functions

function Get-ClusterSubnetCidr() {
    param (
        [Parameter(Mandatory)] [string] $VnetStartIp,
        [Parameter(Mandatory)] [int] $OrdinalClusterNumber,
        [Parameter(Mandatory)] [string] $NetworkPlugin
    )

    if ($NetworkPlugin -eq "azure") {
        return Get-ClusterSubnetCidrForAzure -VnetStartIp $VnetStartIp -OrdinalClusterNumber $OrdinalClusterNumber
    } elseif ($NetworkPlugin -eq "kubenet") {
        return Get-ClusterSubnetCidrForKubenet -VnetStartIp $VnetStartIp -OrdinalClusterNumber $OrdinalClusterNumber
    } else {
        throw "NetworkPlugin $NetworkPlugin not supported"
    }
}

# We assume that we have a /24 subnet for the cluster and a /28 subnet for the pods.
# We leave 256 IPs for general infrastructure, and 3 * 256 IPs for the clusters.
function Get-ClusterSubnetCidrForKubenet() {
    param (
        [Parameter(Mandatory)] [string] $VnetStartIp,
        [Parameter(Mandatory)] [int] $OrdinalClusterNumber
    )

    $startIpParts = $VnetStartIp.Split(".");

    # calcuate the cidr of a /28 subnet based on version and start ip
    $foruthOctet = ($OrdinalClusterNumber * 16) % 256
    $thirdOctetOffset = [math]::Floor(($OrdinalClusterNumber * 16) / 256);

    # we can only have 0, 1, 2 as offset, otherwise we are out of range
    if ($thirdOctetOffset -gt 2) {
        throw "Cluster number $OrdinalClusterNumber is out of range"
    }

    # add 2 to the third octet, because the first two ips are reserved for infrastructure
    $thirdOctet = [int]$startIpParts[2] + 1 + $thirdOctetOffset

    return $startIpParts[0] + "." + $startIpParts[1] + "." + $thirdOctet + "." + $foruthOctet + "/28"       
}

function Get-ClusterSubnetCidrForAzure() {
    param (
        [Parameter(Mandatory)] [string] $VnetStartIp,
        [Parameter(Mandatory)] [int] $OrdinalClusterNumber
    )

    # as we have only 3 * 256 IPs for the cluster, we can only have 3 clusters (0 - 2)
    if ($OrdinalClusterNumber -gt 2) {
        throw "Version $OrdinalClusterNumber is out of range"
    }

    $startIpParts = $VnetStartIp.Split(".");
    $thirdOctet = [int]$startIpParts[2] + 1 + $OrdinalClusterNumber

    return $startIpParts[0] + "." + $startIpParts[1] + "." + $thirdOctet + ".0/24"
}

#endregion

# if no network plugin is provided, use kubenet
if (-not $NetworkPlugin) {
    $NetworkPlugin = "kubenet"
}

# only azure and kubenet are supported
if ($NetworkPlugin -ne "azure" -and $NetworkPlugin -ne "kubenet") {
    throw "NetworkPlugin $NetworkPlugin not supported"
}

$ordinalClusterNumber = [int]($Version)
$subnetAddressSpace = Get-ClusterSubnetCidr `
    -VnetStartIp $VnetStartIp `
    -OrdinalClusterNumber $ordinalClusterNumber `
    -NetworkPlugin $NetworkPlugin

Write-Host "subnetAddressSpace: $subnetAddressSpace"

# define names
$application = "microtodo"
$resourceGroupName = "rg-$application-$Environment"
$containerRegistryName = "thinkexception"

$vnetName = "vnet-$application-$Environment"
$subnetName = "subnet-$application-$Environment-$Version"

$managedIdentityName = "identity-$application-$Environment-$Version"

$clusterName = "aks-$application-$Environment-$Version"

# create subnet for cluster in vnet
Write-Host "Check if subnet $subnetName exists in vnet $vnetName"
$clusterSubnetId = az network vnet subnet show `
    --resource-group $resourceGroupName `
    --vnet-name $vnetName `
    --name $subnetName `
    --query id -o tsv

if (-not $clusterSubnetId) {
    Write-Host "Creating subnet $subnetName in vnet $vnetName"
    $clusterSubnetId = az network vnet subnet create `
        --resource-group $resourceGroupName `
        --vnet-name $vnetName `
        --name $subnetName `
        --address-prefixes $subnetAddressSpace `
        --query id -o tsv
}
else {
    Write-Host "Subnet $subnetName in vnet $vnetName already exists"
}

# create identity for the cluster
Write-Host "Checking if identity $managedIdentityName exists"
$identityId = az identity show `
    --resource-group $resourceGroupName `
    --name $managedIdentityName `
    --query id -o tsv

if (-not $identityId) {
    Write-Host "Creating identity $managedIdentityName"
    $identityId = az identity create `
        --resource-group $resourceGroupName `
        --name $managedIdentityName `
        --query id -o tsv
} else {
    Write-Host "Identity $managedIdentityName already exists"
}

# create cluster in subnet
az aks create `
    --resource-group $resourceGroupName `
    --name $clusterName `
    --node-count 1 `
    --node-vm-size "Standard_B2s" `
    --network-plugin $NetworkPlugin `
    --vnet-subnet-id $clusterSubnetId `
    --auto-upgrade-channel "stable" `
    --enable-managed-identity `
    --assign-identity $identityId `
    --assign-kubelet-identity $identityId `
    --attach-acr $containerRegistryName

