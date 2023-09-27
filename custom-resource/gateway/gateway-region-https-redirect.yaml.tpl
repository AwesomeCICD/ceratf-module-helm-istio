apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: ${circleci_region}-https-redirect
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
    - "*"