apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: ${target_domain_stringified}-demos
  namespace: ${ingress_namespace}
spec:
  secretName: ${target_domain_stringified}-demos
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
    - "*.demo.${target_domain}"
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
    group: cert-manager.io