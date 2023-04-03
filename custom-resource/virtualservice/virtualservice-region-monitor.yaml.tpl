kind: VirtualService
apiVersion: networking.istio.io/v1alpha3
metadata:
  name: ${circleci_region}-istio-ingress-virtual-service
  namespace: ${istio_namespace}
spec:
  hosts:      # which incoming host are we applying the proxy rules to???
    - "monitor.${target_domain}"
  gateways:
    - ${circleci_region}-istio-gateway
  http:
    - match:
      - uri:
          prefix: "/grafana"
      route:
      - destination:
          host: grafana
          port:
            number: 3000

    - route:
      - destination:
          host: kiali
          port:
            number: 20001

    - match:
      - uri:
          prefix: "/prometheus"
      route:
      - destination:
          host: prometheus
          port:
            number: 9090