locals {
  target_domain_stringified = replace(var.target_domain, ".", "-")
}

data "kubernetes_service_v1" "istio_ingress" {
  metadata {
    name      = "istio-ingress"
    namespace = var.istio_namespace
  }
}