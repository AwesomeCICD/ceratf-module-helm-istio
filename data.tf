locals {
  target_domain_stringified = replace(var.target_domain, ".", "-")
  oidc_provider_name        = trimprefix(data.aws_iam_openid_connect_provider.this_region.arn, "https://")
  k8s_r53_access_sa_name    = "cera-${var.circleci_region}-eks-regional-r53-access"
}

data "aws_region" "current" {}

data "kubernetes_service_v1" "istio_ingress" {
  metadata {
    name      = "istio-ingress"
    namespace = var.istio_namespace
  }
}

# Get data from OIDC provider attached to EKS cluster so that we can create IRSA for cert-manager access to R53 via k8s SAs
data "aws_eks_cluster" "this_region" {
  name = var.eks_cluster_name
}

data "aws_iam_openid_connect_provider" "this_region" {
  url = data.aws_eks_cluster.this_region.identity[0].oidc[0].issuer
}