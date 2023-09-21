kind: VirtualService
apiVersion: networking.istio.io/v1alpha3
metadata:
  name: ${circleci_region}-dev-fieldguide
  namespace: ${ingress_namespace}
spec:
  hosts:      # which incoming host are we applying the proxy rules to???
    - "dev.fieldguide.${target_domain}"
  gateways:
    - ${circleci_region}-fieldguide-gateway
  http:
    - route:
      - destination:
          host: fieldguide.guidebook-dev.svc.cluster.local
          port:
            number: 8080