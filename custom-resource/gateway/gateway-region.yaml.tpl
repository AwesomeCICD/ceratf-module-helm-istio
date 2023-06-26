apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: ${circleci_region}-istio-gateway
  namespace: ${istio_namespace}
spec:
  selector:
    istio: ingress # use Istio default gateway implementation
  servers:
  - port:
       name: http
       number: 80
       protocol: HTTP2
    tls:
       httpsRedirect: true
    hosts:
    - "${target_domain}" # BOA prod
    - "monitor.${target_domain}" # Kiali / Grafana
    - "vault.${target_domain}" # Vault
  - port:
      number: 443
      name: https
      protocol: HTTPS
    tls:
      mode: SIMPLE
      credentialName: "${target_domain_stringified}"
    hosts:
    - "${target_domain}" # BOA prod
    - "monitor.${target_domain}" # Kiali / Grafana
    - "vault.${target_domain}" # Vault
