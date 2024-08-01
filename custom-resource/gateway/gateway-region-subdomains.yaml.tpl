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
    - "*.${target_domain}" # All subdomains
    - "*.demo.${target_domain}" # all demo domains
    - "*.dev.${target_domain}" # all demo domains
  - port:
      number: 443
      name: https
      protocol: HTTPS
    tls:
      mode: SIMPLE
      credentialName: "${target_domain_stringified}-subdomains"
    hosts:
    - "*.${target_domain}" # all subdomains
    - "*.demo.${target_domain}" # all demo domains
    - "*.dev.${target_domain}" # all demo domains