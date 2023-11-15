# https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/

# watch the hpa / deployment
kubectl get hpa microtodo-todos-api --watch
kubectl get deployment microtodo-todos-api

# generate load
kubectl run -i --tty load-generator1 --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://microtodo-todos-api:80/swagger/index.html; done"
kubectl run -i --tty load-generator2 --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://microtodo-todos-api:80/swagger/index.html; done"