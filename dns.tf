/*
#Istio ingress LB
#a04ebe15fe03d4254b494f4af55876ae-2072504753.ap-northeast-1.elb.amazonaws.com
# Actual there's probably a way to retrieve this dynamically... hmm

kubectl provider -> k get svc -n ${var.istio_namespace} ${helm_release.istio_ingress.chartname(?)} | jq ...
k get svc istio-ingress -n istio-system -o yaml | yq '.status.loadBalancer.ingress[0].hostname' 

Actually...
*/

resource "aws_route53_record" "records" {
  for_each = toset([
    "app.server4.",
    "dev.vault.",
    "dev.",
    "docker.nexus.",
    "monitor.",
    "nexus.",
    "server4.",
    "vault."
  ])

  zone_id = var.r53_zone_id
  name    = each.key
  type    = "CNAME"
  ttl     = 5

  records = [data.kubernetes_service_v1.istio_ingress.status.0.load_balancer.0.ingress.0.hostname]
}

resource "aws_route53_record" "apex_record" {

  zone_id = var.r53_zone_id
  name    = ""
  type    = "A"
  ttl     = 5

  records = [data.kubernetes_service_v1.istio_ingress.status.0.load_balancer.0.ingress.0.hostname]
}



####
# Create AWS and k8s resources for cert manager to perform DNS01 auth
# See https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html
####

resource "aws_iam_role" "k8s_route53_access" {
  name = "cera-${var.circleci_region}-eks-regional-r53-access"

  assume_role_policy = templatefile(
    "${path.module}/iam/k8s_r53_role_trust_policy.json.tpl",
    {
      oidc_provider_name       = local.oidc_provider_name,
      istio_namespace          = var.istio_namespace,
      r53_service_account_name = local.k8s_r53_access_sa_name # necessary to avoid TF cycle error between k8s SA and IAM role
    }
  )

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_policy" "k8s_route53_access" {
  name = "cera-${var.circleci_region}-eks-regional-r53-access"
  policy = templatefile(
    "${path.module}/iam/k8s_r53_role_policy.json.tpl",
    {
      r53_zone_id = var.r53_zone_id
    }
  )
}

resource "aws_iam_role_policy_attachment" "k8s_route53_access" {
  role       = aws_iam_role.k8s_route53_access.name
  policy_arn = aws_iam_policy.k8s_route53_access.arn
}


resource "kubernetes_service_account_v1" "k8s_route53_access" {
  metadata {
    name      = local.k8s_r53_access_sa_name # necessary to avoid TF cycle error between k8s SA and IAM role
    namespace = var.istio_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" : "${aws_iam_role.k8s_route53_access.arn}"
    }
  }

}