param (
    [Parameter(Mandatory)] [string] $Environment,
    [Parameter(Mandatory)] [string] $Version,
    [Parameter()] [string] $Location = "westeurope"
)

$prevPwd = $PWD; Set-Location -ErrorAction Stop -LiteralPath $PSScriptRoot

$application = "microtodo"
$resourceGroupName = "rg-$application-$Environment"
$clusterName = "aks-$application-$Environment-$Version"
$mcResourceGroupName = "MC_" + $resourceGroupName + "_" + $clusterName + "_" + $Location
$dnsLabel = "$application-$Environment-$Version"

az aks get-credentials -n $clusterName -g $resourceGroupName --overwrite-existing  

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

kubectl create namespace ingress-nginx --dry-run=client -o yaml | kubectl apply -f -

helm install nginx-ingress ingress-nginx/ingress-nginx `
    --namespace ingress-nginx `
    --set controller.replicaCount=3 `
    --set controller.nodeSelector."kubernetes\.io/os"=linux `
    --set defaultBackend.nodeSelector."kubernetes\.io/os"=linux `
    --set controller.admissionWebhooks.patch.nodeSelector."kubernetes\.io/os"=linux
    # private load balancer
    # --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-resource-group"="$LOADBALANCER_RESOURCE_GROUP" `
    # --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-internal"="true" `
    # --set controller.service.loadBalancerIP=$LoadBalancerIp

kubectl apply -f ingress-class.yaml
kubectl apply -f configmap-ingress-nginx-headers.yaml

# the former command creates an public ip address, which we need to query to set the dns label
$ingressIpName=$(az network public-ip list -g  $mcResourceGroupName  --query "[?tags.\""k8s-azure-service\""=='ingress-nginx/nginx-ingress-ingress-nginx-controller'].name | [0]")  
az network public-ip update -g $mcResourceGroupName -n $ingressIpName --dns-name $dnsLabel 

$prevPwd | Set-Location