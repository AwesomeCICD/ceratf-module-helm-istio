apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: ${target_domain_stringified}-fieldguide
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
    - "fieldguide.${root_domain_zone_name}" # global
    - "dev.fieldguide.${target_domain}" # local DOmain
  - port:
      number: 443
      name: https
      protocol: HTTPS
    tls:
      mode: SIMPLE
      credentialName: "${target_domain_stringified}-fieldguide"
    hosts:
    - "fieldguide.${root_domain_zone_name}" # global
    - "dev.fieldguide.${target_domain}" # local DOmain
