$Location = "germanywestcentral"

#.\infrastructure\azure\base.ps1 dev 10.1.4.0/22 $Location 
#.\infrastructure\azure\loganalyticsworkspace.ps1 dev 
.\infrastructure\azure\cluster.ps1 dev 1 10.1.4.0
.\infrastructure\azure\cluster-enableworkloadidentity.ps1 dev 1
.\infrastructure\azure\workloadidentity.ps1 dev 1

.\infrastructure\kubernetes\ingress\install-ingresscontroller.ps1 dev 1 $Location
.\infrastructure\kubernetes\certmanager\install-certmanager.ps1 dev 1 nginx      
# .\infrastructure\kubernetes\sqlserver\deploy-feature.ps1 

.\prepare-branch.ps1 dev 1 04-ingress $Location

# .\application\todos\kubernetes\deploy-feature.ps1 
.\application\frontend\kubernetes\api\deploy-feature-nginx.ps1
.\application\frontend\kubernetes\client\deploy-feature-nginx.ps1

https://microtodo-dev-1.germanywestcentral.cloudapp.azure.com/api/swagger

.\infrastructure\kubernetes\chaosmesh\install-chaosmesh.ps1 dev 1