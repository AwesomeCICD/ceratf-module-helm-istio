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

  repository       = "https://kiali.org/helm-charts"
  chart            = "kiali-operator"
  namespace        = var.kiali_namespace
  create_namespace = true # we'll create it separately so we can label it properly
  atomic           = true #purges chart on failed deploy
  #version          = var.istio_chart_version  # Not sure about this -- maybe latest is okay?


  values = [
    file("${path.module}/values/kiali-operator.yaml")
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
  atomic           = true #purges chart on failed deploy
  #version          = var.istio_chart_version  # Not sure about this -- maybe latest is okay?


  values = [
    file("${path.module}/values/cert-manager.yaml")
  ]
}



resource "helm_release" "jaeger_operator" {

  name = "jaeger-operator"

  repository       = "https://jaegertracing.github.io/helm-charts"
  chart            = "jaeger-operator"
  namespace        = var.istio_namespace
  create_namespace = true # we'll create it separately so we can label it properly
  atomic           = false #true #purges chart on failed deploy
  #version          = var.istio_chart_version  # Not sure about this -- maybe latest is okay?

  values = [
    file("${path.module}/values/jaeger-operator.yaml")
  ]

  depends_on = [
    kubernetes_namespace.istio,
    helm_release.cert_manager
  ]
}

# This is just a quickstart demo and should be replaced by a more robust Prometheus deployment
# Also, it would probably be better to use native TF k8s resources instead of this manifest file
#resource "kubernetes_manifest" "prometheus_quickstart" {
#  manifest = data.http.prometheus_manifest.response_body
#}


# https://github.com/AwesomeCICD/cera-services/tree/main/istio
#TODO: Jaeger
#TODO: Grafana
#TODO: Cert Manager