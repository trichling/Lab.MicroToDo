param (
    [Parameter(Mandatory)] [string] $Environment,
    [Parameter(Mandatory)] [string] $Version
)

$prevPwd = $PWD; Set-Location -ErrorAction Stop -LiteralPath $PSScriptRoot

# https://learn.microsoft.com/en-us/azure/application-gateway/tutorial-ingress-controller-add-on-existing

$location = "westeurope"
$application = "microtodo"
$resourceGroupName = "rg-$application-$Environment"
$vnetName = "vnet-$application-$Environment"
$containerRegistryName = "thinkexception"
$managedIdentityName = "identity-$application-$Environment-$Version"

$clusterName = "aks-$application-$Environment-$Version"
$clusterSubnetName = "subnet-$application-$Environment-$Version"
$clusterSubnetAddressSpace = "10.1.5.0/24"

$applicationGatewaySubnetName = "subnet-$application-$Environment-application-gateway"
$applicationGatewaySubnetAddressSpace = "10.1.4.0/24"
$applicationGatewayName = "appgw-$application-$Environment"
$applicationGatewayPublicIpName = "pip-$application-$Environment-application-gateway"
$applicationGatewayPublicIpDnsName = "$application-$Environment-$Version"

# cluster subnet
$clusterSubnetId = az network vnet subnet create `
    --resource-group $resourceGroupName `
    --vnet-name $vnetName `
    --name $clusterSubnetName `
    --address-prefixes $clusterSubnetAddressSpace `
    --query id -o tsv

# create identity for the cluster
$identityId = az identity create `
    --resource-group $resourceGroupName `
    --name $managedIdentityName `
    --query id -o tsv

# create the cluster
az aks create `
    --resource-group $resourceGroupName `
    --name $clusterName `
    --node-count 1 `
    --node-vm-size "Standard_B2s" `
    --network-plugin azure `
    --vnet-subnet-id $clusterSubnetId `
    --auto-upgrade-channel "stable" `
    --enable-managed-identity `
    --assign-identity $identityId `
    --assign-kubelet-identity $identityId `
    --attach-acr $containerRegistryName 

    # public ip for application gateway
az network public-ip create `
    -n $applicationGatewayPublicIpName `
    -g $resourceGroupName `
    --allocation-method Static `
    --sku Standard

# the former command creates an public ip address, which we need to query to set the dns label
az network public-ip update -g $resourceGroupName -n $applicationGatewayPublicIpName --dns-name $applicationGatewayPublicIpDnsName 


# appgw subnet
az network vnet subnet create `
    --name $applicationGatewaySubnetName `
    --resource-group $resourceGroupName `
    --vnet-name $vnetName `
    --address-prefixes $applicationGatewaySubnetAddressSpace 

# add aks route table to application gateway subnet (needed if you want to use kubenet)
$aksRouteTableId = az network route-table list `
    -g $mcResourceGroupName `
    --query "[?contains(name, 'MC_')].id" `
    -o tsv

az network vnet subnet update `
    --name $applicationGatewaySubnetName `
    --resource-group $resourceGroupName `
    --vnet-name $vnetName `
    --route-table $aksRouteTableId

# application gateway
az network application-gateway create `
    -n $applicationGatewayName `
    -g $resourceGroupName `
    --sku Standard_v2 `
    --public-ip-address $applicationGatewayPublicIpName `
    --vnet-name $vnetName `
    --subnet $applicationGatewaySubnetName `
    --priority 100

# add application gateway addon
$applicationGatewayId = az network application-gateway show `
    -n $applicationGatewayName `
    -g $resourceGroupName `
    -o tsv `
    --query "id"

az aks enable-addons `
    -n $clusterName `
    -g $resourceGroupName `
    -a ingress-appgw `
    --appgw-id $applicationGatewayId


# deploy a sample application
az aks get-credentials -n $clusterName -g $resourceGroupName
kubectl apply -k ../../testing/aspnetapp/overlays/feature-withoutssl  # https://raw.githubusercontent.com/Azure/application-gateway-kubernetes-ingress/master/docs/examples/aspnetapp.yaml

kubectl get ingress

$prevPwd | Set-Location