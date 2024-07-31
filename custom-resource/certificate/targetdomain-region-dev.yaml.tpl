apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: ${target_domain_stringified}-dev
  namespace: ${ingress_namespace}
spec:
  secretName: ${target_domain_stringified}-dev
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
    - "dev.${target_domain}" # BOA dev
    - "dev.*.${target_domain}" # 
  issuerRef:
    name: letsencrypt-staging
    kind: ClusterIssuer
    group: cert-manager.io