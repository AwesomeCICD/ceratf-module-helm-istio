apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: ${circleci_region}-istio-gateway
  namespace: ${istio_namespace}
spec:
  selector:
    istio: ingressgateway # use Istio default gateway implementation
  servers:
  - port:
      number: 443
      name: https
      protocol: HTTPS
    tls:
      mode: SIMPLE
      credentialName: "${circleci_region}-${target_domain_stringified}"
    hosts:
    - "${circleci_region}.${target_domain}" # BOA prod
    - "monitor.${circleci_region}.${target_domain}" # Kiali / Grafana
    - "vault.${circleci_region}.${target_domain}" # Vault