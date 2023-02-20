### Required 

#variable "global_oidc_provider_arn" {
#  description = "ARN of OIDC provider used for cluster access from AwesomeCICD CircleCI org via AWS SSO."
#}

variable "cluster_oidc_provider_arn" {
  description = "ARN of OIDC provider attached to EKS cluster for IRSA."
}

variable "cluster_security_group_id" {
  description = "EKS controlplane SG ID."
}

variable "node_security_group_id" {
  description = "EKS node SG ID."
}

variable "circleci_region" {
  description = "Region in which services will be deployed."
}

variable "target_domain" {
  description = "Domain for which certs will be provisioned."
}

variable "r53_subdomain_zone_id" {
  description = "Hosted zone ID for domain."
}

### Optional 

variable "istio_chart_version" {
  description = "Helm chart version"
  type        = string
  default     = "1.16"
}

variable "istio_namespace" {
  description = "Namespace to which Istio Helm chart will be deployed"
  type        = string
  default     = "istio-system"
}

variable "kiali_namespace" {
  description = "Namespace to which Kiali Operator Helm chart will be deployed"
  type        = string
  default     = "kiali-operator"
}

variable "cert_manager_namespace" {
  description = "Namespace to which Kiali Operator Helm chart will be deployed"
  type        = string
  default     = "cert-manager"
}

variable "namespace_labels" {
  description = "Labels to be applied to namespaces."
  type        = map(string)
  default     = {}
}

variable "prometheus_version" {
  description = "Version of prom/prometheus image to deploy."
  default     = "v2.34.0"
}

variable "aws_region" {}
variable "aws_account_no" {}