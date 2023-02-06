#-------------------------------------------------------------------------------
# ISTIO VIRTUAL SERVICES
#-------------------------------------------------------------------------------

resource "kubernetes_manifest" "istio_virtualservice_region" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/custom-resource/virtualservice/virtualservice-region.yaml.tpl",
      {
        istio_namespace = var.istio_namespace,
        circleci_region = var.circleci_region,
        target_domain   = var.target_domain
      }
    )
  )
}


resource "kubernetes_manifest" "istio_virtualservice_region_dev" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/custom-resource/virtualservice/virtualservice-region-dev.yaml.tpl",
      {
        istio_namespace = var.istio_namespace,
        circleci_region = var.circleci_region,
        target_domain   = var.target_domain
      }
    )
  )
}

resource "kubernetes_manifest" "istio_virtualservice_region_dev_vault" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/custom-resource/virtualservice/virtualservice-region-dev-vault.yaml.tpl",
      {
        istio_namespace = var.istio_namespace,
        circleci_region = var.circleci_region,
        target_domain   = var.target_domain
      }
    )
  )
}



resource "kubernetes_manifest" "istio_virtualservice_region_monitor" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/custom-resource/virtualservice/virtualservice-region-monitor.yaml.tpl",
      {
        istio_namespace = var.istio_namespace,
        circleci_region = var.circleci_region,
        target_domain   = var.target_domain
      }
    )
  )
}

resource "kubernetes_manifest" "istio_virtualservice_region_nexus_docker" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/custom-resource/virtualservice/virtualservice-region-nexus-docker.yaml.tpl",
      {
        istio_namespace = var.istio_namespace,
        circleci_region = var.circleci_region,
        target_domain   = var.target_domain
      }
    )
  )
}

resource "kubernetes_manifest" "istio_virtualservice_region_nexus" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/custom-resource/virtualservice/virtualservice-region-nexus.yaml.tpl",
      {
        istio_namespace = var.istio_namespace,
        circleci_region = var.circleci_region,
        target_domain   = var.target_domain
      }
    )
  )
}

resource "kubernetes_manifest" "istio_virtualservice_region_server4" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/custom-resource/virtualservice/virtualservice-region-server4.yaml.tpl",
      {
        istio_namespace = var.istio_namespace,
        circleci_region = var.circleci_region,
        target_domain   = var.target_domain
      }
    )
  )
}

resource "kubernetes_manifest" "istio_virtualservice_region_vault" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/custom-resource/virtualservice/virtualservice-region-vault.yaml.tpl",
      {
        istio_namespace = var.istio_namespace,
        circleci_region = var.circleci_region,
        target_domain   = var.target_domain
      }
    )
  )
}