#-------------------------------------------------------------------------------
# ISTIO VIRTUAL SERVICES
#-------------------------------------------------------------------------------

resource "kubectl_manifest" "istio_virtualservice_region" {
  yaml_body = yamldecode(
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


resource "kubectl_manifest" "istio_virtualservice_region_dev" {
  yaml_body = yamldecode(
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

resource "kubectl_manifest" "istio_virtualservice_region_dev_vault" {
  yaml_body = yamldecode(
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



resource "kubectl_manifest" "istio_virtualservice_region_monitor" {
  yaml_body = yamldecode(
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

resource "kubectl_manifest" "istio_virtualservice_region_nexus_docker" {
  yaml_body = yamldecode(
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

resource "kubectl_manifest" "istio_virtualservice_region_nexus" {
  yaml_body = yamldecode(
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

resource "kubectl_manifest" "istio_virtualservice_region_server4" {
  yaml_body = yamldecode(
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

resource "kubectl_manifest" "istio_virtualservice_region_vault" {
  yaml_body = yamldecode(
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