# issuer-lets-encrypt-staging.yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
  namespace: ${istio_namespace}
spec:
  acme:
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    email: solutions@circleci.com
    privateKeySecretRef:
      name: letsencrypt-staging
    solvers:
    - http01:
        ingress:
          class: istio