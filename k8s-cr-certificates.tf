resource "kubernetes_manifest" "certmanager_letsencrypt_clusterissuer_prod" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/custom-resource/certificate/letsencrypt-clusterissuer-prod.yaml.tpl",
      {
        istio_namespace = var.istio_namespace,
        aws_region      = data.aws_region.current.name,
        r53_zone_id     = var.r53_zone_id,
        irsa_role_arn   = aws_iam_role.k8s_route53_access.arn
      }
    )
  )
}

resource "kubernetes_manifest" "certmanager_letsencrypt_clusterissuer_staging" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/custom-resource/certificate/letsencrypt-clusterissuer-staging.yaml.tpl",
      {
        istio_namespace = var.istio_namespace,
        aws_region      = data.aws_region.current.name,
        r53_zone_id     = var.r53_zone_id,
        irsa_role_arn   = aws_iam_role.k8s_route53_access.arn
      }
    )
  )
}

resource "kubernetes_manifest" "certmanager_cert_targetdomain_region" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/custom-resource/certificate/targetdomain-region.yaml.tpl",
      {
        istio_namespace           = var.istio_namespace,
        target_domain             = var.target_domain,
        target_domain_stringified = local.target_domain_stringified
      }
    )
  )
}

resource "kubernetes_manifest" "certmanager_cert_targetdomain_region_dev" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/custom-resource/certificate/targetdomain-region-dev.yaml.tpl",
      {
        istio_namespace           = var.istio_namespace,
        target_domain             = var.target_domain,
        target_domain_stringified = local.target_domain_stringified
      }
    )
  )
}

resource "kubernetes_manifest" "certmanager_cert_targetdomain_region_nexus" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/custom-resource/certificate/targetdomain-region-nexus.yaml.tpl",
      {
        istio_namespace           = var.istio_namespace,
        target_domain             = var.target_domain,
        target_domain_stringified = local.target_domain_stringified
      }
    )
  )
}

resource "kubernetes_manifest" "certmanager_cert_targetdomain_region_server4" {
  manifest = yamldecode(
    templatefile(
      "${path.module}/custom-resource/certificate/targetdomain-region-server4.yaml.tpl",
      {
        istio_namespace           = var.istio_namespace,
        target_domain             = var.target_domain,
        target_domain_stringified = local.target_domain_stringified
      }
    )
  )
}