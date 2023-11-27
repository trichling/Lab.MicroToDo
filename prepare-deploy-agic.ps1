param (
    [Parameter()] [string] $Environment,
    [Parameter()] [string] $Version
)

if ($Environment -eq $null -or $Environment -eq "") {
    $Environment = "dev"
}

# if version is null or empty
if ($Version -eq $null -or $Version -eq "") {
    $Version = "0"
}

az aks get-credentials --resource-group rg-microtodo-$Environment --name aks-microtodo-$Environment-$Version --overwrite-existing

./prepare-branch.ps1 $Version 04-ingress
./deploy-feature-agic.ps1