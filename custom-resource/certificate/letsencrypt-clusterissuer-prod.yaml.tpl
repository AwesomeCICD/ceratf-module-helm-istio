# Prod Lets Encrypt Issuer
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
  namespace: istio-ingress
spec:
  acme:
    email: solutions@circleci.com
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    #regional domain certs
    - dns01:
        route53:
          region: ${aws_region}
          hostedZoneID: ${r53_subdomain_zone_id}
      selector:
        dnsZones:
          - ${target_domain}
    #global fieldguide cert
    - dns01:
        route53:
          region: ${aws_region}
          hostedZoneID: ${r53_root_zone_id}
      selector:
        dnsNames:
          - fieldguide.${r53_root_zone_name}
