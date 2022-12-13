apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: nexus-${circleci_region}-${target_domain_stringified}
  namespace: ${istio_namespace}
spec:
  secretName: nexus-${circleci_region}-${target_domain_stringified}
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
    - "nexus.${circleci_region}.${target_domain}"
    - "docker.nexus.${circleci_region}.${target_domain}"
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
    group: cert-manager.io