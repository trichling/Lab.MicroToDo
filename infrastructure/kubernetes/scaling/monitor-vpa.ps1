# https://learn.microsoft.com/en-us/azure/aks/vertical-pod-autoscaler

# watch out for vpa-admission-controller and vpa-recommender and vpa-updater
kubectl get pods -n kube-system

kubectl apply -f ../../testing/vpa/hamster.yaml

# watch out for ressource request
kubectl get pods -l app=hamster
kubectl describe pod <hamster pod>

# watch creation of new pods
kubectl get --watch pods -l app=hamster
kubectl describe pod hamster-<exampleID> # watch for increased ressources

