resource "kubectl_manifest" "certmanager_letsencrypt_clusterissuer_prod" {
  yaml_body = templatefile(
    "${path.module}/custom-resource/certificate/letsencrypt-clusterissuer-prod.yaml.tpl",
    {
      issuer_name           = "letsencrypt-prod",
      ingress_namespace     = var.ingress_namespace,
      aws_region            = var.aws_region,
      r53_subdomain_zone_id = var.r53_subdomain_zone_id,
      r53_root_zone_id      = var.root_domain_zone_id,
      r53_root_zone_name    = var.root_domain_zone_name,
      irsa_role_arn         = aws_iam_role.k8s_route53_access.arn,
      target_domain         = var.target_domain
    }
  )
  depends_on = [
    helm_release.cert_manager
  ]
}

resource "kubectl_manifest" "certmanager_letsencrypt_clusterissuer_staging" {
  yaml_body = templatefile(
    "${path.module}/custom-resource/certificate/letsencrypt-clusterissuer-staging.yaml.tpl",
    {
      ingress_namespace     = var.ingress_namespace,
      aws_region            = var.aws_region,
      r53_subdomain_zone_id = var.r53_subdomain_zone_id,
      r53_root_zone_name    = var.root_domain_zone_name,
      r53_root_zone_id      = var.root_domain_zone_id,
      irsa_role_arn         = aws_iam_role.k8s_route53_access.arn,
      target_domain         = var.target_domain
    }
  )
  depends_on = [
    helm_release.cert_manager
  ]
}

resource "kubectl_manifest" "certmanager_letsencrypt_clusterissuer_labs" {
  count = var.target_domain_aux != "" ? 1 : 0
  yaml_body = templatefile(
    # !IMPROTANT - same file, different inputs
    "${path.module}/custom-resource/certificate/letsencrypt-clusterissuer-prod.yaml.tpl",
    {
      issuer_name           = "letsencrypt-${local.aux_target_domain_stringified}",
      ingress_namespace     = var.ingress_namespace,
      aws_region            = var.aws_region,
      r53_subdomain_zone_id = var.r53_subdomain_zone_id_aux,
      r53_root_zone_name    = var.aux_domain_zone_name,
      r53_root_zone_id      = var.aux_domain_zone_id,
      irsa_role_arn         = aws_iam_role.k8s_route53_access.arn,
      target_domain         = var.target_domain_aux
    }
  )
  depends_on = [
    helm_release.cert_manager
  ]
}

resource "kubectl_manifest" "certmanager_cert_targetdomain_region" {
  yaml_body = templatefile(
    "${path.module}/custom-resource/certificate/targetdomain-region.yaml.tpl",
    {
      ingress_namespace         = var.ingress_namespace,
      target_domain             = var.target_domain,
      target_domain_stringified = local.target_domain_stringified
    }
  )
  depends_on = [
    helm_release.cert_manager
  ]
}

resource "kubectl_manifest" "certmanager_cert_targetdomain_subdomains" {
  yaml_body = templatefile(
    "${path.module}/custom-resource/certificate/targetdomain-region-subdomains.yaml.tpl",
    {
      ingress_namespace         = var.ingress_namespace,
      target_domain             = var.target_domain,
      target_domain_stringified = local.target_domain_stringified
    }
  )
  depends_on = [
    helm_release.cert_manager
  ]
}
resource "kubectl_manifest" "certmanager_cert_targetdomain_fieldguide" {
  yaml_body = templatefile(
    "${path.module}/custom-resource/certificate/targetdomain-region-fieldguide.yaml.tpl",
    {
      ingress_namespace         = var.ingress_namespace,
      target_domain             = var.target_domain,
      root_domain_zone_name     = var.root_domain_zone_name,
      target_domain_stringified = local.target_domain_stringified
    }
  )
  depends_on = [
    helm_release.cert_manager
  ]
}

resource "kubectl_manifest" "certmanager_cert_circleci_labs" {
  count = var.target_domain_aux != "" ? 1 : 0
  yaml_body = templatefile(
    "${path.module}/custom-resource/certificate/alt-domain.yaml.tpl",
    {
      ingress_namespace         = var.ingress_namespace,
      aux_root_domain_zone_name = var.aux_domain_zone_name,
      aux_domain                = var.target_domain_aux,
      aux_domain_stringified    = local.aux_target_domain_stringified
    }
  )
  depends_on = [
    helm_release.cert_manager
  ]
}

