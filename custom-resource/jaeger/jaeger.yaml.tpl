apiVersion: jaegertracing.io/v1
kind: Jaeger
metadata:
  name: jaeger-allinone
  namespace: ${istio_namespace}