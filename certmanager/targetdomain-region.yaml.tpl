apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: ${circleci_region}-${target_domain_stringified}
  namespace: ${istio_namespace}
spec:
  secretName: ${circleci_region}-${target_domain_stringified}
  duration: 2160h # 90d
  renewBefore: 360h # 15d
  isCA: false
  privateKey:
    algorithm: RSA
    encoding: PKCS1
    size: 2048
  usages:
    - server auth
    - client auth
  dnsNames:
    - "${circleci_region}.${target_domain}" # BOA prod
    - "monitor.${circleci_region}.${target_domain}" # Kiali / Grafana
    - "vault.${circleci_region}.${target_domain}" # Vault
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
    group: cert-manager.io