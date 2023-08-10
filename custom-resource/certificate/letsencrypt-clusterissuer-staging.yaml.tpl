# Staging Lets Encrypt Issuer
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    email: solutions@circleci.com
    privateKeySecretRef:
      name: letsencrypt-staging
    solvers:
    - dns01:
        route53:
          region: ${aws_region}
          hostedZoneID: ${r53_subdomain_zone_id}
      selector:
        dnsZones:
          - ${target_domain}
