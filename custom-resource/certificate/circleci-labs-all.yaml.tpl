apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: cirlceci-labs
  namespace: ${ingress_namespace}
spec:
  secretName: cirlceci-labs
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
    - "dev.cirlceci-labs.com" 
    - "cirlceci-labs.com" 
    - "*.cirlceci-labs.com"
  issuerRef:
    name: letsencrypt-cirlceci-labs
    kind: ClusterIssuer
    group: cert-manager.io