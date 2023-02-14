#-------------------------------------------------------------------------------
# ISTIO RESOURCES
#-------------------------------------------------------------------------------

# Istio Helm charts

resource "kubernetes_namespace" "istio" {
  metadata {
    name   = var.istio_namespace
    labels = var.namespace_labels
  }
}

resource "helm_release" "istio_base" {

  name = "istio-base"

  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  namespace        = var.istio_namespace
  version          = var.istio_chart_version #not sure yet if we need to pin this -- might constantly grab the latest chart leading to unintended destroy/creates?
  create_namespace = false                   # we'll create it separately so we can label it properly
  atomic           = true                    #purges chart on failed deploy

  values = [
    file("${path.module}/helm-values/istio-base.yaml")
  ]

  depends_on = [
    kubernetes_namespace.istio
  ]
}

resource "helm_release" "istiod" {

  name = "istiod"

  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  namespace        = var.istio_namespace
  version          = var.istio_chart_version
  create_namespace = false
  atomic           = true

  values = [
    file("${path.module}/helm-values/istiod.yaml")
  ]

  depends_on = [
    kubernetes_namespace.istio,
    helm_release.istio_base
  ]
}


resource "helm_release" "istio_ingress" {

  name = "istio-ingress"

  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  namespace        = var.istio_namespace
  version          = var.istio_chart_version
  create_namespace = false
  atomic           = true

  values = [
    file("${path.module}/helm-values/istio-ingress.yaml")
  ]

  depends_on = [
    kubernetes_namespace.istio,
    helm_release.istio_base,
    helm_release.istiod
  ]
}

resource "helm_release" "istio_egress" {

  name = "istio-egress"

  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  namespace        = var.istio_namespace
  version          = var.istio_chart_version
  create_namespace = false
  atomic           = true

  values = [
    file("${path.module}/helm-values/istio-egress.yaml")
  ]

  depends_on = [
    kubernetes_namespace.istio,
    helm_release.istio_base,
    helm_release.istiod
  ]
}

# Istio DNS resources

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
  name    = var.target_domain
  type    = "A"

  #see data.tf for details
  alias {
    name                   = data.kubernetes_service_v1.istio_ingress.status.0.load_balancer.0.ingress.0.hostname
    zone_id                = data.aws_elb.istio_ingress.zone_id 
    evaluate_target_health = true
  }

  #records = [data.kubernetes_service_v1.istio_ingress.status.0.load_balancer.0.ingress.0.hostname]
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
      oidc_provider_arn        = data.aws_iam_openid_connect_provider.cera_global.arn
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





#-------------------------------------------------------------------------------
# ISTIO PERIPHERAL SERVICES
#-------------------------------------------------------------------------------


resource "helm_release" "kiali_operator" {

  name = "kiali-operator"

  repository       = "https://kiali.org/helm-charts"
  chart            = "kiali-operator"
  namespace        = var.kiali_namespace
  create_namespace = true # we'll create it separately so we can label it properly
  atomic           = true



  values = [
    file("${path.module}/helm-values/kiali-operator.yaml")
  ]

  depends_on = [
    kubernetes_namespace.istio
  ]
}



resource "helm_release" "cert_manager" {

  name = "cert-manager"

  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = var.cert_manager_namespace
  create_namespace = true # we'll create it separately so we can label it properly
  atomic           = true



  values = [
    file("${path.module}/helm-values/cert-manager.yaml")
  ]
}



resource "helm_release" "jaeger_operator" {

  name = "jaeger-operator"

  repository       = "https://jaegertracing.github.io/helm-charts"
  chart            = "jaeger-operator"
  namespace        = var.istio_namespace
  create_namespace = false
  atomic           = true


  values = [
    file("${path.module}/helm-values/jaeger-operator.yaml")
  ]

  depends_on = [
    kubernetes_namespace.istio,
    helm_release.cert_manager
  ]
}



#-------------------------------------------------------------------------------
# GRAFANA RESOURCES
#-------------------------------------------------------------------------------

resource "helm_release" "grafana" {

  name = "grafana"

  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = var.istio_namespace
  create_namespace = false
  atomic           = true

  values = [
    templatefile(
      "${path.module}/helm-values/grafana.yaml.tpl",
      {
        target_domain = var.target_domain
      }
    )
  ]

  depends_on = [
    kubernetes_namespace.istio,
    kubernetes_config_map_v1.istio_grafana_dashboards,
    kubernetes_config_map_v1.istio_services_grafana_dashboards
  ]
}

# These config maps contain the dashboards that will be loaded into Grafana after it is deployed via Helm.

resource "kubernetes_config_map_v1" "istio_grafana_dashboards" {

  metadata {
    name      = "istio-grafana-dashboards"
    namespace = var.istio_namespace
  }

  data = yamldecode(file("${path.module}/app-config/grafana/istio-grafana-dashboards.yaml"))
}

resource "kubernetes_config_map_v1" "istio_services_grafana_dashboards" {

  metadata {
    name      = "istio-services-grafana-dashboards"
    namespace = var.istio_namespace
  }

  data = yamldecode(file("${path.module}/app-config/grafana/istio-services-grafana-dashboards.yaml"))
}