apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: fieldguide-${target_domain_stringified}
  namespace: ${ingress_namespace}
spec:
  secretName: fieldguide-${target_domain_stringified}
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
    - "fieldguide.${target_domain}" 
    - "dev.fieldguide.${target_domain}" 
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
    group: cert-manager.io