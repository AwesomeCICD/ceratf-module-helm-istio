apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: server4-${circleci_region}-${target_domain_stringified}
  namespace: ${istio_namespace}
spec:
  secretName: server4-${circleci_region}-${target_domain_stringified}
  duration: 2160h0m0s # 90d
  renewBefore: 360h0m0s # 15d
  isCA: null #false
  privateKey:
    algorithm: RSA
    encoding: PKCS1
    size: 2048
  usages:
    - server auth
    - client auth
  dnsNames:
    - "server4.${circleci_region}.${target_domain}"
    - "app.server4.${circleci_region}.${target_domain}" # Server Front End
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
    group: cert-manager.io
