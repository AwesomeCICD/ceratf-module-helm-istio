resource "kubernetes_manifest" "certmanager_letsencrypt_clusterissuer_prod" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/custom-resources/certificate/letsencrypt-clusterissuer-prod.yaml.tpl",
      {
        istio_namespace = var.istio_namespace
      }
    )
  )
}

resource "kubernetes_manifest" "certmanager_letsencrypt_clusterissuer_staging" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/custom-resources/certificate/letsencrypt-clusterissuer-staging.yaml.tpl",
      {
        istio_namespace = var.istio_namespace
      }
    )
  )
}

resource "kubernetes_manifest" "certmanager_cert_targetdomain_region" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/custom-resources/certificate/targetdomain-region.yaml.tpl",
      {
        istio_namespace           = var.istio_namespace,
        circleci_region           = var.circleci_region,
        target_domain             = var.target_domain,
        target_domain_stringified = local.target_domain_stringified
      }
    )
  )
}

resource "kubernetes_manifest" "certmanager_cert_targetdomain_region_dev" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/custom-resources/certificate/targetdomain-region-dev.yaml.tpl",
      {
        istio_namespace           = var.istio_namespace,
        circleci_region           = var.circleci_region,
        target_domain             = var.target_domain,
        target_domain_stringified = local.target_domain_stringified
      }
    )
  )
}

resource "kubernetes_manifest" "certmanager_cert_targetdomain_region_nexus" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/custom-resources/certificate/targetdomain-region-nexus.yaml.tpl",
      {
        istio_namespace           = var.istio_namespace,
        circleci_region           = var.circleci_region,
        target_domain             = var.target_domain,
        target_domain_stringified = local.target_domain_stringified
      }
    )
  )
}

resource "kubernetes_manifest" "certmanager_cert_targetdomain_region_server4" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/custom-resources/certificate/targetdomain-region-server4.yaml.tpl",
      {
        istio_namespace           = var.istio_namespace,
        circleci_region           = var.circleci_region,
        target_domain             = var.target_domain,
        target_domain_stringified = local.target_domain_stringified
      }
    )
  )
}