resource "kubernetes_namespace" "istio" {
  metadata {
    name   = var.namespace
    labels = var.namespace_labels
  }
}

resource "helm_release" "istio" {

  name = "istio"

  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  namespace        = var.namespace
  version          = var.chart_version #not sure yet if we need to pin this -- might constantly grab the latest chart leading to unintended destroy/creates?
  create_namespace = false # we'll create it separately so we can label it properly


  values = [
    file("${path.module}/values.yaml")
  ]

  depends_on = [
    kubernetes_namespace.istio
  ]
}