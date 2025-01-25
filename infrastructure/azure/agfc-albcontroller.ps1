# https://learn.microsoft.com/en-us/azure/application-gateway/for-containers/quickstart-deploy-application-gateway-for-containers-alb-controller?tabs=install-helm-windows

param (
    [Parameter(Mandatory)] [string] $Environment,
    [Parameter(Mandatory)] [string] $Version,
    [Parameter()] [string] $NetworkPlugin
)

# Register required resource providers on Azure.
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.Network
az provider register --namespace Microsoft.NetworkFunction
az provider register --namespace Microsoft.ServiceNetworking

# Install Azure CLI extensions.
az extension add --name alb

# define names
$application = "microtodo"
$resourceGroupName = "rg-$application-$Environment"
$containerRegistryName = "thinkexception"
$vnetName = "vnet-$application-$Environment"
$subnetName = "subnet-$application-$Environment-$Version"
$managedIdentityName = "identity-$application-$Environment-$Version"
$clusterName = "aks-$application-$Environment-$Version"

az aks update -g $resourceGroupName -n $clusterName --enable-oidc-issuer --enable-workload-identity --no-wait

$mcResourceGroup=$(az aks show --resource-group $resourceGroupName --name $clusterName --query "nodeResourceGroup" -o tsv)
$mcResourceGroupId=$(az group show --name $mcResourceGroup --query id -otsv)
$principalId="$(az identity show -g $resourceGroupName -n $managedIdentityName --query principalId -otsv)"

# Apply Reader role to the AKS managed cluster resource group for the newly provisioned identity
az role assignment create --assignee-object-id $principalId --assignee-principal-type ServicePrincipal --scope $mcResourceGroupId --role "acdd72a7-3385-48ef-bd42-f606fba81ae7"

# Set up federated identity with the OIDC issuer
$aksOidcIssuer="$(az aks show -n $clusterName -g $resourceGroupName --query "oidcIssuerProfile.issuerUrl" -o tsv)"
az identity federated-credential create --name "azure-alb-identity" `
    --identity-name $managedIdentityName `
    --resource-group $resourceGroupName `
    --issuer $aksOidcIssuer `
    --subject "system:serviceaccount:azure-alb-system:alb-controller-sa"

# Install the ALB-Controller
az aks get-credentials --resource-group $resourceGroupName --name $clusterName --overwrite-existing

$helmNamespace='default'
$controllerNamespace='azure-alb-system'
helm install alb-controller oci://mcr.microsoft.com/application-lb/charts/alb-controller `
     --namespace $helmNamespace `
     --set albController.namespace=$controllerNamespace `
     --set albController.podIdentity.clientID=$(az identity show -g $resourceGroupName -n $managedIdentityName --query clientId -o tsv)

# Verify the installation
kubectl get pods -n azure-alb-system
kubectl get gatewayclass azure-alb-external -o yaml
