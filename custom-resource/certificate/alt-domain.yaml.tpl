apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: ${aux_domain_stringified}
  namespace: ${ingress_namespace}
spec:
  secretName: ${aux_domain_stringified}
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
    - "${aux_root_domain_zone_name}" 
    - "*.${aux_root_domain_zone_name}"
    - "*.${aux_domain}"
  issuerRef:
    name: letsencrypt-${aux_domain_stringified}
    kind: ClusterIssuer
    group: cert-manager.io