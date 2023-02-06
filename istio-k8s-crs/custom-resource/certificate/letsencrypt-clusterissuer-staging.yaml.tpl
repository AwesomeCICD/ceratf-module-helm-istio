# Staging Lets Encrypt Issuer
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
  #namespace: ${istio_namespace}
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
          hostedZoneID: ${r53_zone_id}
          role: ${irsa_role_arn}
      # I don't think we need a selector since we've only got one zone
      #selector:
      #  dnsZones:
      #    - "example.com"

#    solvers:
#   - http01:
#        ingress:
#          class: istio