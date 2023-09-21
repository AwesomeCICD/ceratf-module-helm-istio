apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: ${circleci_region}-fieldguide-gateway
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
    - "fieldguide.circleci-labs.com" #global GTM
    - "fieldguide.${target_domain}" # prod
    - "dev.fieldguide.${target_domain}" # dev
  - port:
      number: 443
      name: https
      protocol: HTTPS
    tls:
      mode: SIMPLE
      credentialName: "fieldguide-${target_domain_stringified}"
    hosts:
    - "fieldguide.circleci-labs.com"
    - "fieldguide.${target_domain}" 
    - "dev.fieldguide.${target_domain}" 
