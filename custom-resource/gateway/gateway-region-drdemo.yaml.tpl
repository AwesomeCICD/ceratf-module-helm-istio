apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: ${circleci_region}-istio-gateway-drdemo
  namespace: ${ingress_namespace}
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
      credentialName: "${target_domain_stringified}-drdemo"
    hosts:
    - "dr-demo.${target_domain}" 