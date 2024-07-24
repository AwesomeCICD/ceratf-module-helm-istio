apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app.kubernetes.io/instance: ${jaeger_name}
    app.kubernetes.io/name: ${jaeger_name}
  name: ${jaeger_name}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: ${jaeger_name}
subjects:
- kind: ServiceAccount
  name: ${jaeger_name}
  namespace: ${istio_namespace}
