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
    file("${path.module}/values/istio-base.yaml")
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
  create_namespace = false # we'll create it separately so we can label it properly
  atomic           = true  #purges chart on failed deploy

  values = [
    file("${path.module}/values/istiod.yaml")
  ]

  depends_on = [
    kubernetes_namespace.istio,
    helm_release.istio_base
  ]
}


resource "helm_release" "kiali_operator" {

  name = "kiali-operator"

  repository = "https://kiali.org/helm-charts"
  chart      = "kiali-operator"
  namespace  = var.kiali_namespace
  #version          = var.istio_chart_version  # Not sure about this -- maybe latest is okay?
  create_namespace = true # we'll create it separately so we can label it properly
  atomic           = true #purges chart on failed deploy

  values = [
    file("${path.module}/values/kiali-operator.yaml")
  ]

  depends_on = [
    kubernetes_namespace.istio
  ]
}

# This is just a quickstart demo and should be replaced by a more robust Prometheus deployment
# Also, it would probably be better to use native TF k8s resources instead of this manifest file
#resource "kubernetes_manifest" "prometheus_quickstart" {
#  manifest = data.http.prometheus_manifest.response_body
#}