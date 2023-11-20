param (
    [Parameter(Mandatory)] [string] $Environment,
    [Parameter(Mandatory)] [string] $Version
)

# https://learn.microsoft.com/en-us/azure/application-gateway/tutorial-ingress-controller-add-on-existing

$location = "westeurope"
$application = "microtodo"
$resourceGroupName = "rg-$application-$Environment"
$vnetName = "vnet-$application-$Environment"

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

# create the cluster
az aks create `
    -n $clusterName `
    -g $resourceGroupName `
    --vnet-subnet-id $clusterSubnetId `
    --network-plugin azure `
    --enable-managed-identity

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
kubectl apply -f https://raw.githubusercontent.com/Azure/application-gateway-kubernetes-ingress/master/docs/examples/aspnetapp.yaml

kubectl get ingress