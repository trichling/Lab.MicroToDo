- Goto https://labs.play-with-k8s.com/
- add 3 instances
- on node 1 run the cluster initaliziation
    kubeadm init --apiserver-advertise-address $(hostname -i) --pod-network-cidr 10.5.0.0/16
    export KUBECONFIG=/etc/kubernetes/admin.conf
- on node 1 install the pod network
    kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter.yaml
- on node 2 and 3 join the cluster, copy the command from the output of kubeadm init
    kubeadm join 192.168.0.8:6443 --token SOMETOKEN \
         --discovery-token-ca-cert-hash SOMEHASH
- on node1 verify the nodes
    kubectl get nodes -o wide
- on node1 deploy something
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/website/master/content/en/examples/application/nginx-app.yaml