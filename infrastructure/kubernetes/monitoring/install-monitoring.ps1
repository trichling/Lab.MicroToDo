param (
    [Parameter(Mandatory)] [string] $Environment,
    [Parameter(Mandatory)] [string] $Version
)

# https://semaphoreci.com/blog/prometheus-grafana-kubernetes-helm

$prevPwd = $PWD; Set-Location -ErrorAction Stop -LiteralPath $PSScriptRoot

$location = "westeurope"
$application = "microtodo"
$resourceGroupName = "rg-$application-$Environment"
$clusterName = "aks-$application-$Environment-$Version"

az aks get-credentials `
    --resource-group $resourceGroupName `
    --name $clusterName `
    --overwrite-existing

kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade prometheus prometheus-community/prometheus `
    --install `
    --namespace monitoring

$prometheusPodName = $(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=prometheus,app.kubernetes.io/instance=prometheus" -o jsonpath="{.items[0].metadata.name}")
# kubectl port-forward $prometheusPodName 9090:9090 -n monitoring    

helm repo add grafana https://grafana.github.io/helm-charts 
helm repo update
helm upgrade grafana grafana/grafana `
    --install `
    --namespace monitoring 

$passwordBase64 = $(kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}")
$password = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($passwordBase64))
$username = "admin"
$grafanaPodName = $(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
# kubectl port-forward $grafanaPodName 3000:3000 -n monitoring

# Set http://prometheus-server:80 as server url for the prometheus datasource
# Import the GrafanK8sDashboard.json (from https://grafana.com/grafana/dashboards/10856-k8-cluster/) under http://localhost:3000/dashboard/import

# uninstall everything
# helm uninstall grafana -n monitoring
# helm uninstall prometheus -n monitoring
# kubectl delete namespace monitoring



$prevPwd | Set-Location