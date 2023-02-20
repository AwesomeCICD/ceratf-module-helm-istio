#-------------------------------------------------------------------------------
# ISTIO GATEWAYS
#-------------------------------------------------------------------------------


resource "kubernetes_manifest" "istio_gateway_region" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/custom-resource/gateway/gateway-region.yaml.tpl",
      {
        istio_namespace           = var.istio_namespace,
        circleci_region           = var.circleci_region,
        target_domain             = var.target_domain,
        target_domain_stringified = local.target_domain_stringified
      }
    )
  )
}

resource "kubernetes_manifest" "istio_gateway_region_dev" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/custom-resource/gateway/gateway-region-dev.yaml.tpl",
      {
        istio_namespace           = var.istio_namespace,
        circleci_region           = var.circleci_region,
        target_domain             = var.target_domain,
        target_domain_stringified = local.target_domain_stringified
      }
    )
  )
}

resource "kubernetes_manifest" "istio_gateway_region_nexus" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/custom-resource/gateway/gateway-region-nexus.yaml.tpl",
      {
        istio_namespace           = var.istio_namespace,
        circleci_region           = var.circleci_region,
        target_domain             = var.target_domain,
        target_domain_stringified = local.target_domain_stringified
      }
    )
  )
}

resource "kubernetes_manifest" "istio_gateway_region_server4" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/custom-resource/gateway/gateway-region-server4.yaml.tpl",
      {
        istio_namespace           = var.istio_namespace,
        circleci_region           = var.circleci_region,
        target_domain             = var.target_domain,
        target_domain_stringified = local.target_domain_stringified
      }
    )
  )
}




