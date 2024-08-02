apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: ${target_domain_stringified}-subdomains
  namespace: ${ingress_namespace}
spec:
  secretName: ${target_domain_stringified}-subdomains
  duration: 2160h0m0s # 90d
  renewBefore: 720h0m0s # 30d
  isCA: null #false
  privateKey:
    algorithm: RSA
    encoding: PKCS1
    size: 2048
  usages:
    - server auth
    - client auth
  dnsNames:
    - "*.${target_domain}"
    - "*.demo.${target_domain}"
    - "*.dev.${target_domain}"
    - "*.nexus.${target_domain}"
  issuerRef:
    name: letsencrypt-${target_domain_stringified}
    kind: ClusterIssuer
    group: cert-manager.io