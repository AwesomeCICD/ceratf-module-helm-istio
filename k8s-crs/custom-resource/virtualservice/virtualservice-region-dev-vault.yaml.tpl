kind: VirtualService
apiVersion: networking.istio.io/v1alpha3
metadata:
  name: vault-dev-virtual-service
  namespace: ${istio_namespace}
spec:
  hosts:
    - "dev.vault.${target_domain}"
  gateways:
    - ${circleci_region}-istio-gateway-2
  http:
    - route:
      - destination:
          host: hashicorp-vault-dev.vault-dev.svc.cluster.local #dev namespace
          port:
            number: 8200