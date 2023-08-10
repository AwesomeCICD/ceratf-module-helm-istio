# ceratf-module-helm-istio
Terraform module using Helm to deploy Istio.


## Destroying a Cluster

1. Re-run most recent deploy wit SSH debug. (Rerun should be a 0 change apply)
2. Run `terraform destroy` from project directory inside CCI job
3. Once it get's to `deleting istio namespace` you need to run the finalizer fix below.
4. Once it gets to deleting OIDC, Launch Templates, or Cluster, you need to delete OIDC provider and LT's from AWS.

### Destroy Istio Namespace
For whatever reason istio NM gets stuck.

```
module.helm_istio.kubernetes_namespace.istio: Still destroying... [id=istio-system, 10s elapsed]
module.helm_istio.kubernetes_namespace.istio: Still destroying... [id=istio-system, 20s elapsed]
module.helm_istio.kubernetes_namespace.istio: Still destroying... [id=istio-system, 30s elapsed]
module.helm_istio.kubernetes_namespace.istio: Still destroying... [id=istio-system, 40s elapsed]
module.helm_istio.kubernetes_namespace.istio: Still destroying... [id=istio-system, 50s elapsed]
```

Fix
```
 kubectl get kiali.kiali.io/kiali -o yaml -n istio-system > temp.yaml

 # remove `finalizers` from manifest (or set to empty)

 kubectl apply -f temp.yaml
```