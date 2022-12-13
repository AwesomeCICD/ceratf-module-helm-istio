# These config maps contain the dashboards that will be loaded into Grafana after it is deployed via Helm.

resource "kubernetes_config_map_v1" "istio_grafana_dashboards" {

  metadata {
    name      = "istio-grafana-dashboards"
    namespace = var.istio_namespace
  }

  data = yamldecode(file("${path.module}/grafana/istio-grafana-dashboards.yaml"))
}

resource "kubernetes_config_map_v1" "istio_services_grafana_dashboards" {

  metadata {
    name      = "istio-services-grafana-dashboards"
    namespace = var.istio_namespace
  }

  data = yamldecode(file("${path.module}/grafana/istio-services-grafana-dashboards.yaml"))
}