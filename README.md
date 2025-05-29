# ceratf-module-helm-istio
Terraform module using Helm to deploy Istio.

## Accessing Kiali - Istio Monitoring

Kiali is available to visualize istio traffic, and even edit istio config.
https://monitor.namer.circleci-fieldeng.com/kiali/

To login you will need a valid K8s Service Account Token. That will require you to authenticate to the cluster.  This ensure our publicly exposed kiali is not exploited by 3rd parties.

```
#log into AWS, if you do not already have kubectl configured, see monorepo docs
aws sso login
# switch to appropriate cluster
kubectl config use-context XXXX #dependnt on your local kubectl config
# drop any SA token through base64 decode into clipboard
kubectl get secrets circle-shop -o jsonpath='{.data.token}'  -n circle-shop | base64 -d | pbcopy
```

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