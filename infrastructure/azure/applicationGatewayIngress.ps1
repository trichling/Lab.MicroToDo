param (
    [Parameter(Mandatory)] [string] $Environment,
    [Parameter(Mandatory)] [string] $Version,
    [Parameter] [string] $NetworkPlugin
)

$prevPwd = $PWD; Set-Location -ErrorAction Stop -LiteralPath $PSScriptRoot

# if no network plugin is provided, use kubenet
if (-not $NetworkPlugin) {
    $NetworkPlugin = "kubenet"
}

# https://learn.microsoft.com/en-us/azure/application-gateway/tutorial-ingress-controller-add-on-existing

$application = "microtodo"
$resourceGroupName = "rg-$application-$Environment"
$vnetName = "vnet-$application-$Environment"

$clusterName = "aks-$application-$Environment-$Version"

$applicationGatewaySubnetName = "subnet-$application-$Environment-application-gateway"
$applicationGatewaySubnetAddressSpace = "10.1.4.0/24"
$applicationGatewayName = "appgw-$application-$Environment"
$applicationGatewayPublicIpName = "pip-$application-$Environment-application-gateway"
$applicationGatewayPublicIpDnsName = "$application-$Environment-$Version"

# public ip for application gateway
az network public-ip create `
    -n $applicationGatewayPublicIpName `
    -g $resourceGroupName `
    --allocation-method Static `
    --sku Standard

# the former command creates an public ip address, which we need to query to set the dns label
az network public-ip update -g $resourceGroupName -n $applicationGatewayPublicIpName --dns-name $applicationGatewayPublicIpDnsName 

# appgw subnet
$applicationGatewaySubnetId = az network vnet subnet create `
    --name $applicationGatewaySubnetName `
    --resource-group $resourceGroupName `
    --vnet-name $vnetName `
    --address-prefixes $applicationGatewaySubnetAddressSpace 

# add aks route table to application gateway subnet (needed if you want to use kubenet)
if ($NetworkPlugin -eq "kubenet") {
    # find route table used by aks cluster
    # Get the node resource group
    $nodeResourceGroup = az aks show `
        -n $clusterName `
        -g $resourceGroupName `
        -o tsv `
        --query "nodeResourceGroup"

    # Get the route table ID
    $routeTableId = az network route-table list `
        -g $nodeResourceGroup `
        --query "[].id | [0]" `
        -o tsv

    # associate the route table to Application Gateway's subnet
    az network vnet subnet update `
        --ids $applicationGatewaySubnetId `
        --route-table $routeTableId
}

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