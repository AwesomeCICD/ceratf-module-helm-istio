#-------------------------------------------------------------------------------
# ISTIO VIRTUAL SERVICES
#-------------------------------------------------------------------------------

resource "kubectl_manifest" "istio_virtualservice_region" {
  force_new = true
  yaml_body = templatefile(
    "${path.module}/custom-resource/virtualservice/virtualservice-region.yaml.tpl",
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

resource "kubectl_manifest" "istio_virtualservice_region_dev_vault" {
  force_new = true
  yaml_body = templatefile(
    "${path.module}/custom-resource/virtualservice/virtualservice-region-dev-vault.yaml.tpl",
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

resource "kubectl_manifest" "istio_virtualservice_region_nexus_docker" {
  force_new = true
  yaml_body = templatefile(
    "${path.module}/custom-resource/virtualservice/virtualservice-region-nexus-docker.yaml.tpl",
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

resource "kubectl_manifest" "istio_virtualservice_region_nexus" {
  force_new = true
  yaml_body = templatefile(
    "${path.module}/custom-resource/virtualservice/virtualservice-region-nexus.yaml.tpl",
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

resource "kubectl_manifest" "istio_virtualservice_region_server4" {
  force_new = true
  yaml_body = templatefile(
    "${path.module}/custom-resource/virtualservice/virtualservice-region-server4.yaml.tpl",
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

resource "kubectl_manifest" "istio_virtualservice_region_vault" {
  force_new = true
  yaml_body = templatefile(
    "${path.module}/custom-resource/virtualservice/virtualservice-region-vault.yaml.tpl",
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
resource "kubectl_manifest" "istio_virtualservice_region_fieldguide" {
  force_new = true
  yaml_body = templatefile(
    "${path.module}/custom-resource/virtualservice/virtualservice-region-fieldguide.yaml.tpl",
    {
      ingress_namespace = var.ingress_namespace,
      circleci_region   = var.circleci_region,
      root_domain       = var.root_domain_zone_name,
      target_domain     = var.target_domain
    }
  )
  depends_on = [
    helm_release.istio_ingress
  ]
}
resource "kubectl_manifest" "istio_virtualservice_region_fieldguide_dev" {
  force_new = true
  yaml_body = templatefile(
    "${path.module}/custom-resource/virtualservice/virtualservice-region-fieldguide-dev.yaml.tpl",
    {
      ingress_namespace = var.ingress_namespace,
      circleci_region   = var.circleci_region,
      root_domain       = var.root_domain_zone_name,
      target_domain     = var.target_domain
    }
  )
  depends_on = [
    helm_release.istio_ingress
  ]
}