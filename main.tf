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
  force_update     = true
  recreate_pods    = true
  cleanup_on_fail  = true

  values = [
    file("${path.module}/helm-values/istio-base.yaml")
  ]

  depends_on = [
    kubernetes_namespace.istio,
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
  force_update     = true
  recreate_pods    = true
  cleanup_on_fail  = true

  values = [
    file("${path.module}/helm-values/istiod.yaml")
  ]

  depends_on = [
    kubernetes_namespace.istio,
    helm_release.istio_base
  ]
}


resource "kubernetes_namespace" "istio-ingress" {
  metadata {
    name   = var.ingress_namespace
    labels = var.namespace_labels
  }
}


resource "helm_release" "istio_ingress" {

  name = "istio-ingressgateway"

  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  namespace        = var.ingress_namespace
  version          = var.istio_chart_version
  create_namespace = false
  atomic           = true
  force_update     = true
  recreate_pods    = true
  cleanup_on_fail  = true

  values = [
    file("${path.module}/helm-values/istio-ingress.yaml")
  ]

  depends_on = [
    kubernetes_namespace.istio-ingress,
    helm_release.istio_base,
    helm_release.istiod
  ]
}

resource "helm_release" "metrics_server" {
  name = "metrics-server"

  repository       = "https://kubernetes-sigs.github.io/metrics-server/"
  chart            = "metrics-server"
  create_namespace = false
  atomic           = true

}


# Istio DNS resources

resource "aws_route53_record" "records" {
  for_each = toset([
    "*."
  ])

  zone_id = var.r53_subdomain_zone_id
  name    = each.key
  type    = "CNAME"
  ttl     = 5

  records    = [data.kubernetes_service_v1.istio_ingress.status.0.load_balancer.0.ingress.0.hostname]
  depends_on = [helm_release.istio_ingress]
}

resource "aws_route53_record" "fieldguide_global_record" {
  zone_id = var.root_domain_zone_id
  name    = "fieldguide"
  type    = "A"

  # Using alias gives us health checks without explicit definition of 'HealthCheck'
  #records = [data.kubernetes_service_v1.istio_ingress.status.0.load_balancer.0.ingress.0.hostname]
  alias {
    name                   = data.kubernetes_service_v1.istio_ingress.status.0.load_balancer.0.ingress.0.hostname
    zone_id                = data.aws_elb.istio_ingress.zone_id
    evaluate_target_health = true
  }

  weighted_routing_policy {
    weight = 100 #every region has equal weight, failover based on alias health check is all we rely on
  }

  set_identifier = "fieldguide-${var.circleci_region}"

  depends_on = [helm_release.istio_ingress]
}

resource "aws_route53_record" "apex_record" {

  zone_id = var.r53_subdomain_zone_id
  name    = var.target_domain
  type    = "A"

  #see data.tf for details
  alias {
    name                   = data.kubernetes_service_v1.istio_ingress.status.0.load_balancer.0.ingress.0.hostname
    zone_id                = data.aws_elb.istio_ingress.zone_id
    evaluate_target_health = true
  }
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
      oidc_provider_name       = local.cluster_oidc_provider_name,
      oidc_provider_arn        = var.cluster_oidc_provider_arn,
      cert_manager_namespace   = var.cert_manager_namespace,
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
      r53_zone_id      = var.r53_subdomain_zone_id,
      r53_root_zone_id = var.root_domain_zone_id
    }
  )
}

resource "aws_iam_role_policy_attachment" "k8s_route53_access" {
  role       = aws_iam_role.k8s_route53_access.name
  policy_arn = aws_iam_policy.k8s_route53_access.arn
}





#-------------------------------------------------------------------------------
# KIALI RESOURCES
#-------------------------------------------------------------------------------


resource "helm_release" "kiali_operator" {

  name = "kiali-operator"

  repository       = "https://kiali.org/helm-charts"
  chart            = "kiali-operator"
  namespace        = var.istio_namespace
  create_namespace = false # we'll create it separately so we can label it properly
  atomic           = true
  version          = var.kiali_operator_chart_version



  values = [
    file("${path.module}/helm-values/kiali-operator.yaml")
  ]

  depends_on = [
    kubernetes_namespace.istio,
    helm_release.istiod,
    helm_release.prometheus
  ]
}

resource "kubectl_manifest" "kiali_server" {
  yaml_body = templatefile(
    "${path.module}/custom-resource/kiali/kiali.yaml.tpl",
    {
      istio_namespace = var.istio_namespace,
      auth_strategy   = "anonymous" # we may want to change this later
    }
  )
  depends_on = [
    helm_release.kiali_operator
  ]
}


#-------------------------------------------------------------------------------
# CERT MANAGER HELM CHART
# See k8s-certificate.tf for CRs
#-------------------------------------------------------------------------------

resource "helm_release" "cert_manager" {

  name = "cert-manager"

  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = var.cert_manager_namespace
  create_namespace = true
  atomic           = true
  version          = "1.15.0"

  values = [
    templatefile(
      "${path.module}/helm-values/cert-manager.yaml.tpl",
      {
        r53_access_role_arn    = aws_iam_role.k8s_route53_access.arn,
        k8s_r53_access_sa_name = local.k8s_r53_access_sa_name
      }
    )
  ]

  depends_on = [
    helm_release.istio_ingress
  ]

}

#-------------------------------------------------------------------------------
# JAEGER RESOURCES 
#-------------------------------------------------------------------------------

# Install operator (watches) without instance or clusterrole RBAC
resource "helm_release" "jaeger_operator" {
  name = "jaeger-operator"

  repository       = "https://jaegertracing.github.io/helm-charts"
  chart            = "jaeger-operator"
  namespace        = var.istio_namespace
  create_namespace = false
  atomic           = true
  version          = var.jaeger_chart_version

  values = [
    file("${path.module}/helm-values/jaeger-operator.yaml")
  ]

  depends_on = [
  ]
}

resource "kubectl_manifest" "jaeger_clusterrole" {
  # Bug in jaeger has invalid permissions.
  # https://github.com/jaegertracing/helm-charts/issues/549
  yaml_body = templatefile(
    "${path.module}/custom-resource/jaeger/clusterrole.yaml.tpl",
    {
      istio_namespace = var.istio_namespace,
      jaeger_name     = helm_release.jaeger_operator.name
    }
  )
  depends_on = [
    helm_release.jaeger_operator
  ]
}


resource "kubectl_manifest" "jaeger_server" {
  yaml_body = templatefile(
    "${path.module}/custom-resource/jaeger/jaeger.yaml.tpl",
    {
      istio_namespace = var.istio_namespace
    }
  )
  depends_on = [
    kubectl_manifest.jaeger_clusterrole
  ]
}


#-------------------------------------------------------------------------------
# PROMETHEUS RESOURCES 
#-------------------------------------------------------------------------------

resource "helm_release" "prometheus" {

  name = "prometheus"

  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  namespace        = var.istio_namespace
  create_namespace = false
  atomic           = true
  recreate_pods    = true

  values = [
    file("${path.module}/helm-values/prom.yaml")
  ]

  depends_on = [
    kubernetes_namespace.istio
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
    helm_release.istiod,
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
  depends_on = [
    kubernetes_namespace.istio
  ]
}

resource "kubernetes_config_map_v1" "istio_services_grafana_dashboards" {

  metadata {
    name      = "istio-services-grafana-dashboards"
    namespace = var.istio_namespace
  }

  data = yamldecode(file("${path.module}/app-config/grafana/istio-services-grafana-dashboards.yaml"))
  depends_on = [
    kubernetes_namespace.istio
  ]
}
resource "kubernetes_config_map_v1" "dr_demo_grafana_dashboards" {

  metadata {
    name      = "dr-demo-grafana-dashboards"
    namespace = var.istio_namespace
  }

  data = yamldecode(file("${path.module}/app-config/grafana/dr-demo-grafana-dashboards.yaml"))
  depends_on = [
    kubernetes_namespace.istio
  ]
}
