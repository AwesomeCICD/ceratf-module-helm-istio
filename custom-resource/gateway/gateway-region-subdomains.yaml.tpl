apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: ${circleci_region}-istio-gateway-subdomains
  namespace: ${ingress_namespace}
spec:
  selector:
    istio: ingressgateway # use Istio default gateway implementation
  servers:
  - port:
       name: http
       number: 80
       protocol: HTTP
    tls:
       httpsRedirect: true
    hosts:
    - "nexus/*.nexus.${target_domain}" # only vs in cba-dev prevents conflict
    - "*.demo.${target_domain}" # all demo domains
    - "*.dev.${target_domain}" # all appspace dev domains
    - "dev.${target_domain}" # cba dev domains
    - "vault.${target_domain}" 
    - "monitor.${target_domain}" 
  - port:
      number: 443
      name: https
      protocol: HTTPS
    tls:
      mode: SIMPLE
      credentialName: "${target_domain_stringified}-subdomains"
    hosts:
    - "nexus/*.nexus.${target_domain}" # only vs in cba-dev prevents conflict
    - "*.demo.${target_domain}" # all demo domains
    - "*.dev.${target_domain}" # all appspace dev domains
    - "dev.${target_domain}" # cba dev domains
    - "vault.${target_domain}" 
    - "monitor.${target_domain}" 