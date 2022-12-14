kind: VirtualService
apiVersion: networking.istio.io/v1alpha3
metadata:
  name: vault-virtual-service
  namespace: ${istio_namespace}
spec:
  hosts:
    - "vault.${circleci_region}.${target_domain}"
  gateways:
    - ${circleci_region}-istio-gateway
  http:
    - route:
      - destination:
          host: hashicorp-vault.vault.svc.cluster.local #prod namespace
          port:
            number: 8200