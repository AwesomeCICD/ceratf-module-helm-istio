apiVersion: kiali.io/v1alpha1
kind: Kiali
metadata:
  name: kiali
  namespace: ${istio_namespace}
spec:
  auth:
    strategy: ${auth_strategy}
  deployment:
    accessible_namespaces: ["${istio_namespace}"]
    view_only_mode: false
  server:
    web_root: "/kiali"