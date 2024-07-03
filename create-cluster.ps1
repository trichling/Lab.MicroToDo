$Location = "germanywestcentral"

.\infrastructure\azure\base.ps1 dev 10.1.4.0/22 $Location 
.\infrastructure\azure\loganalyticsworkspace.ps1 dev 
.\infrastructure\azure\cluster.ps1 dev 0 10.1.4.0
.\infrastructure\azure\cluster-enableworkloadidentity.ps1 dev 0
.\infrastructure\azure\workloadidentity.ps1 dev 0

.\infrastructure\kubernetes\ingress\install-ingresscontroller.ps1 dev 0 $Location
.\infrastructure\kubernetes\certmanager\install-certmanager.ps1 dev 0 nginx      
# .\infrastructure\kubernetes\sqlserver\deploy-feature.ps1 

.\prepare-branch.ps1 0 04-ingress $Location

# .\application\todos\kubernetes\deploy-feature.ps1 
.\application\frontend\kubernetes\api\deploy-feature.ps1
.\application\frontend\kubernetes\client\deploy-feature.ps1

https://microtodo-dev-0.germanywestcentral.cloudapp.azure.com/api/swagger

.\infrastructure\kubernetes\chaosmesh\install-chaosmesh.ps1 dev 0