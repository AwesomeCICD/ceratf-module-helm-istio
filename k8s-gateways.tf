#-------------------------------------------------------------------------------
# ISTIO GATEWAYS
#-------------------------------------------------------------------------------


resource "kubectl_manifest" "istio_gateway_region" {
  force_new = true
  yaml_body = templatefile(
    "${path.module}/custom-resource/gateway/gateway-region.yaml.tpl",
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
    "${path.module}/custom-resource/gateway/gateway-region-dev.yaml.tpl",
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

resource "kubectl_manifest" "istio_gateway_region_demos" {
  force_new = true
  yaml_body = templatefile(
    "${path.module}/custom-resource/gateway/gateway-region-demos.yaml.tpl",
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

resource "kubectl_manifest" "istio_gateway_region_drdemo" {
  force_new = true
  yaml_body = templatefile(
    "${path.module}/custom-resource/gateway/gateway-region-drdemo.yaml.tpl",
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

resource "kubectl_manifest" "istio_gateway_region_nexus" {
  force_new = true
  yaml_body = templatefile(
    "${path.module}/custom-resource/gateway/gateway-region-nexus.yaml.tpl",
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

resource "kubectl_manifest" "istio_gateway_region_server4" {
  force_new = true
  yaml_body = templatefile(
    "${path.module}/custom-resource/gateway/gateway-region-server4.yaml.tpl",
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

resource "kubectl_manifest" "istio_gateway_region_fieldguide" {
  force_new = true
  yaml_body = templatefile(
    "${path.module}/custom-resource/gateway/gateway-region-fieldguide.yaml.tpl",
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




