kind: VirtualService
apiVersion: networking.istio.io/v1alpha3
metadata:
  name: ${circleci_region}-prod-fieldguide
  namespace: ${ingress_namespace}
spec:
  hosts:      # which incoming host are we applying the proxy rules to???
    - "fieldguide.${target_domain}"
    - "fieldguide.circleci-labs.com"
  gateways:
    - ${circleci_region}-fieldguide-gateway
  http:
    - route:
      - destination:
          host: fieldguide.guidebook.svc.cluster.local
          port:
            number: 8080