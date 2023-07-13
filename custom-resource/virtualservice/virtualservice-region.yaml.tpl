kind: VirtualService
apiVersion: networking.istio.io/v1alpha3
metadata:
  name: ${circleci_region}-prod-virtual-service
  namespace: ${ingress_namespace}
spec:
  hosts:      # which incoming host are we applying the proxy rules to???
    - "${target_domain}"
  gateways:
    - ${circleci_region}-istio-gateway
  http:
    - route:
      - destination:
          host: frontend.boa.svc.cluster.local
          port:
            number: 80