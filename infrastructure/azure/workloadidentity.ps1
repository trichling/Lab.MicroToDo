param (
    [Parameter(Mandatory)] [string] $Environment,
    [Parameter(Mandatory)] [string] $Version
)
# https://learn.microsoft.com/en-us/azure/aks/learn/tutorial-kubernetes-workload-identity

# define names
$application = "microtodo"
$resourceGroupName = "rg-$application-$Environment"
$managedIdentityName = "identity-$application-$Environment-$Version"
$federatedIdentityName = "federatedidentity-$application-$Environment-$Version"
$clusterName = "aks-$application-$Environment-$Version"

$managedIdentityClientId = $(az identity show --resource-group $resourceGroupName --name $managedIdentityName --query 'clientId' -otsv)
$serviceAccountName = "api"
$serviceAccountNamespace = "default"
$serviceAccount = @"
apiVersion: v1
kind: ServiceAccount
metadata:
    annotations:
        azure.workload.identity/client-id: ${managedIdentityClientId}
    
    name: ${serviceAccountName}
    namespace: ${serviceAccountNamespace}
"@

$serviceAccount | kubectl apply -f -

$aksOidcIssuer = $(az aks show -n $clusterName -g $resourceGroupName --query "oidcIssuerProfile.issuerUrl" -otsv)

az identity federated-credential create `
    --name $federatedIdentityName `
    --identity-name $managedIdentityName `
    --resource-group $resourceGroupName `
    --issuer $aksOidcIssuer `
    --subject "system:serviceaccount:${serviceAccountNamespace}:${serviceAccountName}"