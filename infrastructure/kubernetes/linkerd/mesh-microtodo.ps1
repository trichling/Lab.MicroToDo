kubectl get -n default deploy -o yaml | linkerd inject - | kubectl apply -f -
kubectl rollout restart deployment/microtodo-frontend
kubectl rollout restart deployment/microtodo-frontend-api
kubectl rollout restart deployment/microtodo-todos-api

# verify
kubectl -n default get po -o jsonpath='{.items[*].spec.containers[*].name}'

# check mTls
linkerd viz -n default edges deployment