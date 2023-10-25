resource "kubectl_manifest" "certmanager_letsencrypt_clusterissuer_prod" {
  yaml_body = templatefile(
    "${path.module}/custom-resource/certificate/letsencrypt-clusterissuer-prod.yaml.tpl",
    {
      ingress_namespace     = var.ingress_namespace,
      aws_region            = var.aws_region,
      r53_subdomain_zone_id = var.r53_subdomain_zone_id,
      r53_root_zone_id      = data.terraform_remote_state.ceratf_deployment_global.outputs.r53_root_zone_id,
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
      irsa_role_arn         = aws_iam_role.k8s_route53_access.arn,
      target_domain         = var.target_domain
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

resource "kubectl_manifest" "certmanager_cert_targetdomain_region_dev" {
  yaml_body = templatefile(
    "${path.module}/custom-resource/certificate/targetdomain-region-dev.yaml.tpl",
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

resource "kubectl_manifest" "certmanager_cert_targetdomain_region_nexus" {
  yaml_body = templatefile(
    "${path.module}/custom-resource/certificate/targetdomain-region-nexus.yaml.tpl",
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

resource "kubectl_manifest" "certmanager_cert_targetdomain_region_server4" {
  yaml_body = templatefile(
    "${path.module}/custom-resource/certificate/targetdomain-region-server4.yaml.tpl",
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



resource "kubectl_manifest" "certmanager_cert_targetdomain_region_drdemos" {
  yaml_body = templatefile(
    "${path.module}/custom-resource/certificate/targetdomain-region-drdemo.yaml.tpl",
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

resource "kubectl_manifest" "certmanager_cert_targetdomain_region_demos" {
  yaml_body = templatefile(
    "${path.module}/custom-resource/certificate/targetdomain-region-demos.yaml.tpl",
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

resource "kubectl_manifest" "certmanager_cert_targetdomain_region_fieldguide" {
  yaml_body = templatefile(
    "${path.module}/custom-resource/certificate/targetdomain-region-fieldguide.yaml.tpl",
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