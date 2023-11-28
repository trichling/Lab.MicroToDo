# Chaos-Mesh

- Chaos-Mesh is a cloud-native Chaos Engineering platform that orchestrates chaos on Kubernetes environments.

- Chaos-Mesh was accepted as a [CNCF Sandbox project](https://www.cncf.io/blog/2020/08/05/cncf-to-host-chaos-mesh/) in August 2020.

- Chaos-Mesh is a [Graduated project](https://www.cncf.io/blog/2021/08/11/cncf-announces-chaos-mesh-graduation/) in August 2021.

- It allows to inject faults to Kubernetes applications in order to test the resiliency of the system.

- It is easy to use, and it provides a web UI to configure and manage the chaos experiments.

- Chaos Experiments can be submitted as Kubernetes CRDs as well as via the Web UI.


---

# Installation

```powershell
helm install chaos-mesh chaos-mesh/chaos-mesh `
    --namespace=chaos-mesh `
    --set chaosDaemon.runtime=containerd `
    --set chaosDaemon.socketPath=/run/containerd/containerd.sock `
    --version 2.6.2
```

- Installation depends on the kind of container runtime being used

- In case of AKS this is containerd.

---

# Submitting Chaos Experiments

```yaml
apiVersion: chaos-mesh.org/v1alpha1
kind: NetworkChaos
metadata:
  name: network-delay
spec:
  action: delay # the specific chaos action to inject
  mode: one # the mode to run chaos action; supported modes are one/all/fixed/fixed-percent/random-max-percent
  selector: # pods where to inject chaos actions
    namespaces:
      - default
    labelSelectors:
      'app': 'microtodo-frontend' # the label of the pod for chaos injection
  delay:
    latency: '500ms'
  duration: '1m'
```
