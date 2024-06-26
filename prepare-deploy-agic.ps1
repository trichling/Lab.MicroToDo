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

./prepare-branch.ps1 $Environment $Version latest
./deploy-feature-agic.ps1