param (
    [Parameter(Mandatory)] [string] $Environment,
    [Parameter(Mandatory)] [string] $Version
)

# https://chaos-mesh.org/docs/production-installation-using-helm/

$prevPwd = $PWD; Set-Location -ErrorAction Stop -LiteralPath $PSScriptRoot

$location = "westeurope"
$application = "microtodo"
$resourceGroupName = "rg-$application-$Environment"
$clusterName = "aks-$application-$Environment-$Version"

kubectl create namespace chaos-mesh --dry-run=client -o yaml | kubectl apply -f -

helm repo add chaos-mesh https://charts.chaos-mesh.org
helm repo update chaos-mesh

helm install chaos-mesh chaos-mesh/chaos-mesh -n=chaos-mesh --set chaosDaemon.runtime=containerd --set chaosDaemon.socketPath=/run/containerd/containerd.sock --version 2.6.2

kubectl get pods --namespace chaos-mesh -l app.kubernetes.io/instance=chaos-mesh

kubectl apply -f rbac.yaml

# the token needs to be pasted into chaos dashboard under settings
kubectl create token account-default-manager-zgfsm

$chaosDashboardPodName = $(kubectl get pods --namespace chaos-mesh -l "app.kubernetes.io/name=chaos-mesh,app.kubernetes.io/instance=chaos-mesh,app.kubernetes.io/component=chaos-dashboard" -o jsonpath="{.items[0].metadata.name}")
# kubectl port-forward $chaosDashboardPodName 2333:2333 -n chaos-mesh

$prevPwd | Set-Location