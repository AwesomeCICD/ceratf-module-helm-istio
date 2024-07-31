apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: circleci-labs
  namespace: ${ingress_namespace}
spec:
  selector:
    istio: ingressgateway # use Istio default gateway implementation
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    tls:
      httpsRedirect: true
    hosts:
    - "*.circleci-labs.com"
  - port:
      number: 443
      name: https
      protocol: HTTPS
    tls:
      mode: SIMPLE
      credentialName: "circleci-labs"
    hosts:
    - "*.circleci-labs.com"