# Prod Lets Encrypt Issuer
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
  #namespace: ${istio_namespace}
spec:
  acme:
    email: solutions@circleci.com
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-prod
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