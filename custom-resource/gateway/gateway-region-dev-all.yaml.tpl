apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: ${circleci_region}-istio-gateway-dev-all
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
    - "dev.${target_domain}" # App/Demo 
    - "dev.*.${target_domain}" # All Dev
  - port:
      number: 443
      name: https
      protocol: HTTPS
    tls:
      mode: SIMPLE
      credentialName: "${target_domain_stringified}-dev-all"
    hosts:
    - "dev.${target_domain}" # cba dev
    - "dev.*.${target_domain}" # allinone dev