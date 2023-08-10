kind: VirtualService
apiVersion: networking.istio.io/v1alpha3
metadata:
  name: ${circleci_region}-prod-virtual-service-server4
  namespace: ${ingress_namespace}
spec:
  hosts:    
    - "server4.${target_domain}"
    - "app.server4.${target_domain}" # Server Front End
  gateways:
    - ${circleci_region}-istio-gateway-server4
  http:
    - route:
      - destination:
          host: circleci-proxy.server-4.svc.cluster.local
          port:
            number: 80