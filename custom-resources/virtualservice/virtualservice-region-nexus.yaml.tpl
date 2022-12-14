kind: VirtualService
apiVersion: networking.istio.io/v1alpha3
metadata:
  name: nexus-virtual-service
  namespace: ${istio_namespace}
spec:
  hosts:
    - "nexus.${circleci_region}.${target_domain}"
  gateways:
    - ${circleci_region}-istio-gateway-nexus
  http:
  - route:
    - destination:
        host: nexus-service.nexus.svc.cluster.local #prod namespace
        port:
          number: 8081