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
      #    hostedZoneID: ${r53_subdomain_zone_id}
      #    role: ${irsa_role_arn}
      #selector:
      #  dnsZones:
      #    - ${target_domain}

#    solvers:
#   - http01:
#        ingress:
#          class: istio