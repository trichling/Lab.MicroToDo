param (
    [Parameter] [string] $Environment,
    [Parameter] [string] $Version,
)

if ($Environment -eq $null) {
    $Environment = "dev"
}

if ($Version -eq $null) {
    $Version = "0"
}

prepare-branch.ps1 $Version 04-ingress
deploy-feature-nginx.ps1