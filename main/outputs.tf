output "istio_namespace" {
  value = var.istio_namespace
}

output "irsa_role_arn" {
  value = aws_iam_role.k8s_route53_access.arn
}