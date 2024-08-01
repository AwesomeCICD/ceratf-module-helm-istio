apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: ${target_domain_stringified}-fieldguide
  namespace: ${ingress_namespace}
spec:
  secretName: ${target_domain_stringified}-fieldguide
  duration: 2160h0m0s # 90d
  renewBefore: 720h0m0s # 15d
  isCA: null #false
  privateKey:
    algorithm: RSA
    encoding: PKCS1
    size: 2048
  usages:
    - server auth
    - client auth
  dnsNames:
    - "fieldguide.${root_domain_zone_name}" # global
    - "fieldguide.${target_domain}" # local DOmain
    - "dev.fieldguide.${root_domain_zone_name}" # global
    - "dev.fieldguide.${target_domain}" # local DOmain
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
    group: cert-manager.io