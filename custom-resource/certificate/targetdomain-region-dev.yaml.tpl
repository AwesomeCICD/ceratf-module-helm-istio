apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: dev-${circleci_region}-${target_domain_stringified}
  namespace: ${istio_namespace}
spec:
  secretName: ${circleci_region}-${target_domain_stringified}-2
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
    - "dev.${circleci_region}.${target_domain}" # BOA dev
    - "dev.vault.${circleci_region}.${target_domain}" # Vault dev
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
    group: cert-manager.io