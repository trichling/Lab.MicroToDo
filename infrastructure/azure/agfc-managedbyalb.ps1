# https://learn.microsoft.com/en-us/azure/application-gateway/for-containers/quickstart-create-application-gateway-for-containers-managed-by-alb-controller?tabs=new-subnet-aks-vnet

param (
    [Parameter(Mandatory)] [string] $Environment,
    [Parameter(Mandatory)] [string] $Version,
    [Parameter()] [string] $NetworkPlugin
)

# define names
$application = "microtodo"
$resourceGroupName = "rg-$application-$Environment"
$containerRegistryName = "thinkexception"
$vnetName = "vnet-$application-$Environment"
$subnetName = "subnet-$application-$Environment-$Version"
$managedIdentityName = "identity-$application-$Environment-$Version"
$clusterName = "aks-$application-$Environment-$Version"

$albSubnetName = "subnet-$application-$Environment-alb"
$albSubnetAddressPrefix = "10.1.4.0/24"

az network vnet subnet create `
  --resource-group $resourceGroupName `
  --vnet-name $vnetName `
  --name $albSubnetName  `
  --address-prefixes $albSubnetAddressPrefix `
  --delegations 'Microsoft.ServiceNetworking/trafficControllers'

$vnetId = $(az network vnet show --name $vnetName --resource-group $resourceGroupName --query '[id]' --output tsv)
$albSubnetId=$(az network vnet subnet show --name $albSubnetName --resource-group $resourceGroupName --vnet-name $vnetName --query '[id]' --output tsv)
$mcResourceGroup=$(az aks show --resource-group $resourceGroupName --name $clusterName --query "nodeResourceGroup" -o tsv)
$mcResourceGroupId=$(az group show --name $mcResourceGroup --query id -otsv)
$principalId="$(az identity show -g $resourceGroupName -n $managedIdentityName --query principalId -otsv)"

# associate the route table to Application Gateway's subnet
$routeTableId=$(az network route-table list -g $mcResourceGroup --query "[].id | [0]" -o tsv)

az network vnet subnet update `
--ids $albSubnetId `
--route-table $routeTableId

# Delegate AppGw for Containers Configuration Manager role to AKS Managed Cluster RG
az role assignment create --assignee-object-id $principalId --assignee-principal-type ServicePrincipal --scope $mcResourceGroupId --role "fbc52c3f-28ad-4303-a892-8a056630b8f1" 

# Delegate Network Contributor permission for join to association subnet
az role assignment create --assignee-object-id $principalId --assignee-principal-type ServicePrincipal --scope $albSubnetId --role "4d97b98b-1d4f-4787-a291-c67834d212e7" 
az role assignment create --assignee-object-id $principalId --assignee-principal-type ServicePrincipal --scope $vnetId --role "4d97b98b-1d4f-4787-a291-c67834d212e7" 

# Create ApplicationLoadBalancer Kubernetes Ressource
$namespaceYaml = @"
apiVersion: v1
kind: Namespace
metadata:
  name: alb-test-infra
"@

$namespaceYaml | kubectl apply -f -

$albYaml = @"
apiVersion: alb.networking.azure.io/v1
kind: ApplicationLoadBalancer
metadata:
  name: alb-test
  namespace: alb-test-infra
spec:
  associations:
  - $albSubnetId
"@

$albYaml | kubectl apply -f -

# Verify the installation
kubectl get applicationloadbalancer alb-test -n alb-test-infra -o yaml -w

$gatewayYaml = @"
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: gateway-01
  namespace: alb-test-infra
  annotations:
    alb.networking.azure.io/alb-namespace: alb-test-infra
    alb.networking.azure.io/alb-name: alb-test
spec:
  gatewayClassName: azure-alb-external
  listeners:
  - name: http
    port: 80
    protocol: HTTP
    allowedRoutes:
      namespaces:
        from: Selector
        selector:
          matchLabels:
            shared-gateway-access: "true"
"@

$gatewayYaml | kubectl apply -f -

# annotate namespace
kubectl label namespace default shared-gateway-access=true 

# Get FQDN of gateway
$fqdn=$(kubectl get gateway gateway-01 -n alb-test-infra -o jsonpath='{.status.addresses[0].value}')