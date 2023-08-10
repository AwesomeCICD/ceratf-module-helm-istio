apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: ${circleci_region}-istio-gateway-nexus
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
      - "nexus.${target_domain}" 
      - "docker.nexus.${target_domain}" 
  - port:
      number: 443
      name: https
      protocol: HTTPS
    tls:
      mode: SIMPLE
      credentialName: "nexus-${target_domain_stringified}"
    hosts:
    - "nexus.${target_domain}" 
    - "docker.nexus.${target_domain}" 
