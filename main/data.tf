locals {
  oidc_provider_name     = trimprefix(data.aws_iam_openid_connect_provider.cera_global.arn, "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/")
  k8s_r53_access_sa_name = "cera-${var.circleci_region}-eks-regional-r53-access"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "kubernetes_service_v1" "istio_ingress" {
  metadata {
    name      = "istio-ingress"
    namespace = var.istio_namespace
  }
}

# This data source is used for getting the ELB's Zone ID so that we can create a Route53 apex record pointing to the ELB
# By default, the ELB name is the first 32 chars of the DNSName 
# There's also data.aws_lb_hosted_zone_id, but I think this is more explicitly tied to the actual deployed infra
data "aws_elb" "istio_ingress" {
  name = substr(data.kubernetes_service_v1.istio_ingress.status.0.load_balancer.0.ingress.0.hostname, 0, 32)
}

# Get data from OIDC provider used for granting access to EKS cluster so that we can create IRSA for cert-manager access to R53 via k8s SAs
data "aws_iam_openid_connect_provider" "cera_global" {
  arn = var.oidc_provider_arn
}