resource "kubernetes_manifest" "letsencrypt_clusterissuer" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/certmanager/letsencrypt-clusterissuer.yaml.tpl",
      {
        istio_namespace = var.istio_namespace
      }
    )
  )
}

resource "kubernetes_manifest" "targetdomain_region" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/certmanager/targetdomain-region.yaml.tpl",
      {
        istio_namespace           = var.istio_namespace,
        circleci_region           = var.circleci_region,
        target_domain             = var.target_domain,
        target_domain_stringified = replace(var.target_domain, ".", "-")
      }
    )
  )
}

resource "kubernetes_manifest" "targetdomain_region_dev" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/certmanager/targetdomain-region-dev.yaml.tpl",
      {
        istio_namespace           = var.istio_namespace,
        circleci_region           = var.circleci_region,
        target_domain             = var.target_domain,
        target_domain_stringified = replace(var.target_domain, ".", "-")
      }
    )
  )
}

resource "kubernetes_manifest" "targetdomain_region_nexus" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/certmanager/targetdomain-region-nexus.yaml.tpl",
      {
        istio_namespace           = var.istio_namespace,
        circleci_region           = var.circleci_region,
        target_domain             = var.target_domain,
        target_domain_stringified = replace(var.target_domain, ".", "-")
      }
    )
  )
}

resource "kubernetes_manifest" "targetdomain_region_server4" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/certmanager/targetdomain-region-server4.yaml.tpl",
      {
        istio_namespace           = var.istio_namespace,
        circleci_region           = var.circleci_region,
        target_domain             = var.target_domain,
        target_domain_stringified = replace(var.target_domain, ".", "-")
      }
    )
  )
}