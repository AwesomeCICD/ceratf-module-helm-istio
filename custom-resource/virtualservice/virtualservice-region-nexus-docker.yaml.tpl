kind: VirtualService
apiVersion: networking.istio.io/v1alpha3
metadata:
  name: docker-nexus-virtual-service
  namespace: ${istio_namespace}
spec:
  hosts:
    - "docker.nexus.${target_domain}"
  gateways:
    - ${circleci_region}-istio-gateway-nexus
  http:
  - route:
    - destination:
        host: nxrm-nexus-repository-manager-docker-8443.nexus.svc.cluster.local #prod namespace
        port:
          number: 8443
