linkerd check --pre

linkerd install --crds | kubectl apply -f -
linkerd install | kubectl apply -f -

linkerd check

# install demo app
curl --proto '=https' --tlsv1.2 -sSfL https://run.linkerd.io/emojivoto.yml `
  | kubectl apply -f -

# Port forward to localhost:8080
kubectl -n emojivoto port-forward svc/web-svc 8080:80

# Visit
http://localhost:8080

# Mesh it
kubectl get -n emojivoto deploy -o yaml `
  | linkerd inject - `
  | kubectl apply -f -

# Check the mesh
linkerd -n emojivoto check --proxy

# install the on-cluster metrics stack
linkerd viz install | kubectl apply -f - 
linkerd check

linkerd viz dashboard