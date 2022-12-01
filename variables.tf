variable "cluster_ca_certificate" {
  description = "k8s cluster CA cert"
}

variable "cluster_endpoint" {
  description = "k8s cluster endpoint"
}

variable "cluster_name" {
  description = "k8s cluster name"
}

variable "config_path" {
  description = "path to kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "namespace" {
  description = "namespace to deploy container runner to"
  type        = string
  default     = "istio-system"
}

variable "values" {
  description = "path to values.yaml file"
  type        = string
  default     = "."
}

variable "chart_version" {
  description = "helm chart version"
  type        = string
  default     = ""
}

variable "namespace_labels" {
  description = ""
  type = map(string)
  default = {}
}