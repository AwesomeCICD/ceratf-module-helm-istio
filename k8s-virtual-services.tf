#-------------------------------------------------------------------------------
# ISTIO VIRTUAL SERVICES
#-------------------------------------------------------------------------------

resource "kubectl_manifest" "istio_virtualservice_region" {
  force_new = true
  yaml_body = templatefile(
    "${path.module}/custom-resource/virtualservice/virtualservice-region.yaml.tpl",
    {
      istio_namespace = var.istio_namespace,
      circleci_region = var.circleci_region,
      target_domain   = var.target_domain
    }
  )
  depends_on = [
    helm_release.istio_ingress
  ]
}


resource "kubectl_manifest" "istio_virtualservice_region_dev" {
  force_new = true
  yaml_body = templatefile(
    "${path.module}/custom-resource/virtualservice/virtualservice-region-dev.yaml.tpl",
    {
      istio_namespace = var.istio_namespace,
      circleci_region = var.circleci_region,
      target_domain   = var.target_domain
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
      istio_namespace = var.istio_namespace,
      circleci_region = var.circleci_region,
      target_domain   = var.target_domain
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
      istio_namespace = var.istio_namespace,
      circleci_region = var.circleci_region,
      target_domain   = var.target_domain
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
      istio_namespace = var.istio_namespace,
      circleci_region = var.circleci_region,
      target_domain   = var.target_domain
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
      istio_namespace = var.istio_namespace,
      circleci_region = var.circleci_region,
      target_domain   = var.target_domain
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
      istio_namespace = var.istio_namespace,
      circleci_region = var.circleci_region,
      target_domain   = var.target_domain
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
      istio_namespace = var.istio_namespace,
      circleci_region = var.circleci_region,
      target_domain   = var.target_domain
    }
  )
  depends_on = [
    helm_release.istio_ingress
  ]
}