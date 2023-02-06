locals {
  oidc_provider_name     = trimprefix(data.aws_iam_openid_connect_provider.cera_global.arn, "https://")
  k8s_r53_access_sa_name = "cera-${var.circleci_region}-eks-regional-r53-access"
}

data "aws_region" "current" {}

data "kubernetes_service_v1" "istio_ingress" {
  metadata {
    name      = "istio-ingress"
    namespace = var.istio_namespace
  }
}

# Get data from OIDC provider used for granting access to EKS cluster so that we can create IRSA for cert-manager access to R53 via k8s SAs
data "aws_iam_openid_connect_provider" "cera_global" {
  arn = var.oidc_provider_arn
}