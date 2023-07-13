locals {
  cluster_oidc_provider_name = trimprefix(var.cluster_oidc_provider_arn, "arn:aws:iam::${var.aws_account_no}:oidc-provider/")
  k8s_r53_access_sa_name     = "cera-${var.circleci_region}-eks-regional-r53-access"
  target_domain_stringified  = replace(var.target_domain, ".", "-")
}

data "kubernetes_service_v1" "istio_ingress" {
  metadata {
    name      = "istio-ingressgateway"
    namespace = var.istio_namespace
  }

  depends_on = [
    helm_release.istio_ingress
  ]
}

# This data source is used for getting the ELB's Zone ID so that we can create a Route53 apex record pointing to the ELB
# By default, the ELB name is the first 32 chars of the DNSName 
# There's also data.aws_lb_hosted_zone_id, but I think this is more explicitly tied to the actual deployed infra
data "aws_elb" "istio_ingress" {
  name = substr(data.kubernetes_service_v1.istio_ingress.status.0.load_balancer.0.ingress.0.hostname, 0, 32)

  depends_on = [
    helm_release.istio_ingress
  ]
}

data "aws_iam_openid_connect_provider" "cluster_oidc_provider_arn" {
  arn = var.cluster_oidc_provider_arn
}