kind: VirtualService
apiVersion: networking.istio.io/v1alpha3
metadata:
  name: nexus-virtual-service
  namespace: ${ingress_namespace}
spec:
  hosts:
    - "nexus.${target_domain}"
  gateways:
    - ${circleci_region}-istio-gateway-nexus
  http:
  - route:
    - destination:
        host: nxrm-nexus-repository-manager.nexus.svc.cluster.local #prod namespace
        port:
          number: 8081
