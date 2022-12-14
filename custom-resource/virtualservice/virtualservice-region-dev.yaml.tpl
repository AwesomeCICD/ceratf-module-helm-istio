kind: VirtualService
apiVersion: networking.istio.io/v1alpha3
metadata:
  name: ${circleci_region}-dev-virtual-service
  namespace: ${istio_namespace}
spec:
  hosts:
    - "dev.${target_domain}"
  gateways:
    - ${circleci_region}-istio-gateway-2
  http:
    - route:
      - destination:
          host: frontend.boa-dev.svc.cluster.local #dev namespace
          port:
            number: 80