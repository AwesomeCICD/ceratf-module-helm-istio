#-------------------------------------------------------------------------------
# ISTIO VIRTUAL SERVICES
#-------------------------------------------------------------------------------




resource "kubectl_manifest" "istio_virtualservice_region_monitor" {
  force_new = true
  yaml_body = templatefile(
    "${path.module}/custom-resource/virtualservice/virtualservice-region-monitor.yaml.tpl",
    {
      ingress_namespace = var.ingress_namespace,
      circleci_region   = var.circleci_region,
      target_domain     = var.target_domain
    }
  )
  depends_on = [
    helm_release.istio_ingress
  ]
}