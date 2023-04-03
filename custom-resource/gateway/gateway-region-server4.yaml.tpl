apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: ${circleci_region}-istio-gateway-server4
  namespace: ${istio_namespace}
spec:
  selector:
    istio: ingress # use Istio default gateway implementation
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "server4.${target_domain}"
    - "app.server4.${target_domain}" # Server Front End
  - port:
      number: 443
      name: https
      protocol: HTTPS
    tls:
      mode: SIMPLE
      credentialName: "server4-${target_domain_stringified}"
    hosts:
    - "server4.${target_domain}"
    - "app.server4.${target_domain}" # Server Front End