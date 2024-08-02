apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: gateway-${aux_domain_stringified}
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
    - "${aux_domain_zone_name}" 
    - "*.${aux_domain_zone_name}"
    - "${aux_domain}"
    - "*.${aux_domain}"
  - port:
      number: 443
      name: https
      protocol: HTTPS
    tls:
      mode: SIMPLE
      credentialName: letsencrypt-${aux_domain_stringified}
    hosts:
    - "${aux_domain_zone_name}" 
    - "*.${aux_domain_zone_name}"
    - "${aux_domain}"
    - "*.${aux_domain}"