apiVersion: jaegertracing.io/v1
kind: Jaeger
metadata:
  name: jaeger-allinone
  namespace: ${istio_namespace}
spec:
 template:
  spec:
    containers:
      env:
      - name: QUERY_BASE_PATH
        value: "/jaeger"