#-------------------------------------------------------------------------------
# ISTIO GATEWAYS
#-------------------------------------------------------------------------------



resource "kubectl_manifest" "istio_gateway_fieldguide" {
  force_new = true
  yaml_body = templatefile(
    "${path.module}/custom-resource/gateway/gateway-region-fieldguide.yaml.tpl",
    {
      ingress_namespace         = var.ingress_namespace,
      circleci_region           = var.circleci_region,
      target_domain             = var.target_domain,
      root_domain_zone_name     = var.root_domain_zone_name,
      target_domain_stringified = local.target_domain_stringified
    }
  )
  depends_on = [
    helm_release.istio_ingress
  ]
}

resource "kubectl_manifest" "istio_gateway_region" {
  force_new = true
  yaml_body = templatefile(
    "${path.module}/custom-resource/gateway/gateway-region-root.yaml.tpl",
    {
      ingress_namespace         = var.ingress_namespace,
      circleci_region           = var.circleci_region,
      target_domain             = var.target_domain,
      target_domain_stringified = local.target_domain_stringified
    }
  )
  depends_on = [
    helm_release.istio_ingress
  ]
}

resource "kubectl_manifest" "istio_gateway_region_dev" {
  force_new = true
  yaml_body = templatefile(
    "${path.module}/custom-resource/gateway/gateway-region-dev-all.yaml.tpl",
    {
      ingress_namespace         = var.ingress_namespace,
      circleci_region           = var.circleci_region,
      target_domain             = var.target_domain,
      target_domain_stringified = local.target_domain_stringified
    }
  )
  depends_on = [
    helm_release.istio_ingress
  ]
}

resource "kubectl_manifest" "istio_gateway_region_subdomains" {
  force_new = true
  yaml_body = templatefile(
    "${path.module}/custom-resource/gateway/gateway-region-subdomains.yaml.tpl",
    {
      ingress_namespace         = var.ingress_namespace,
      circleci_region           = var.circleci_region,
      target_domain             = var.target_domain,
      target_domain_stringified = local.target_domain_stringified
    }
  )
  depends_on = [
    helm_release.istio_ingress
  ]
}

resource "kubectl_manifest" "istio_gateway_circleci_labs" {
  force_new = true
  yaml_body = templatefile(
    "${path.module}/custom-resource/gateway/gateway-labs-redirect.yaml.tpl",
    {
      ingress_namespace         = var.ingress_namespace,
      circleci_region           = var.circleci_region,
      target_domain             = var.target_domain,
      target_domain_stringified = local.target_domain_stringified
    }
  )
  depends_on = [
    helm_release.istio_ingress
  ]
}
