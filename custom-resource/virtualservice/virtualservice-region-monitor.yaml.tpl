kind: VirtualService
apiVersion: networking.istio.io/v1alpha3
metadata:
  name: ${circleci_region}-istio-ingress-monitor-subdomain
  namespace: ${ingress_namespace}
spec:
  hosts:      # which incoming host are we applying the proxy rules to???
    - "monitor.${target_domain}"
  gateways:
    - ${circleci_region}-istio-gateway-subdomains
  http:
    - match:
      - uri:
          prefix: "/grafana/"
      rewrite:
        uri: /
      route:
      - destination:
          host: grafana.istio-system.svc.cluster.local
          port:
            number: 3000
    - match:
      - uri:
          prefix: "/prometheus/"
      rewrite:
       uri: /
      route:
      - destination:
          host: prometheus-server.istio-system.svc.cluster.local
          port:
            number: 80
    - match:
      - uri:
          prefix: "/jaeger/"
      rewrite:
       uri: /
      route:
      - destination:
          host: jaeger-allinone-query.istio-system.svc.cluster.local
          port:
            number: 16686
    - route:
      - destination:
          host: kiali.istio-system.svc.cluster.local
          port:
            number: 20001
