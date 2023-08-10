kind: VirtualService
apiVersion: networking.istio.io/v1alpha3
metadata:
  name: vault-virtual-service
  namespace: ${ingress_namespace}
spec:
  hosts:
    - "vault.${target_domain}"
  gateways:
    - ${circleci_region}-istio-gateway
  http:
    - route:
      - destination:
          host: vault.vault.svc.cluster.local #prod namespace
          port:
            number: 8200
