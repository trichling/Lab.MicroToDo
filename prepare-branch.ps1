param (
    [Parameter(Mandatory)] [string] $Environment,
    [Parameter(Mandatory)] [string] $Version,
    [Parameter()] [string] $Tag
)

if (($Tag -eq $null) -or ($Tag -eq '')) {
    $Tag = "feature$Version"
    Write-Host "No tag supplied - using '$Tag'"
}

$configFiles = Get-ChildItem . *.template -rec
foreach ($file in $configFiles) {
    (Get-Content $file.PSPath) |
    Foreach-Object { $_ -replace "<Tag>", $Tag } |
    Foreach-Object { $_ -replace "<Version>", $Version } |
    Foreach-Object { $_ -replace "<Environment>", $Environment } |
    Set-Content $file.PSPath.replace(".template", "")
}
