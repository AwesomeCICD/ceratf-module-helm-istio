apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: ${circleci_region}-istio-gateway-2
  namespace: ${istio_namespace}
spec:
  selector:
    istio: ingress # use Istio default gateway implementation
  servers:
  - port:
      number: 443
      name: https
      protocol: HTTPS
    tls:
      mode: SIMPLE
      credentialName: "${target_domain_stringified}-2"
    hosts:
    - "dev.${target_domain}" # BOA dev
    - "dev.vault.${target_domain}" # Vault dev