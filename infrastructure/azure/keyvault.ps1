param (
    [Parameter(Mandatory)] [string] $Environment,
    [Parameter(Mandatory)] [string] $Version
)

# define names
$location = "westeurope"
$application = "microtodo"
$resourceGroupName = "rg-$application-$Environment"
$keyVaultName = "kv-$application-$Environment-$Version"
$managedIdentityName = "identity-$application-$Environment-$Version"

az keyvault create `
    --resource-group $resourceGroupName `
    --location $location `
    --name $keyVaultName `
    --enable-rbac-authorization

az keyvault secret set `
    --vault-name $keyVaultName `
    --name "microtodo-todos-api-somesecret" `
    --value "Hello!"
    
$managedIdentityClientId = $(az identity show --resource-group $resourceGroupName --name $managedIdentityName --query 'clientId' -otsv)
$keyVaultId = $(az keyvault show --resource-group $resourceGroupName --name $keyVaultName --query 'id' -otsv)
az role assignment create `
    --role "Key Vault Secrets Officer" `
    --assignee $managedIdentityClientId `
    --scope $keyVaultId