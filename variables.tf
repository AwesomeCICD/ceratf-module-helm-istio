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

variable "namespace_labels" {
  description = "Labels to be applied to namespaces."
  type        = map(string)
  default     = {}
}

variable "prometheus_version" {
  description = "Version of prom/prometheus image to deploy."
  default = "v2.34.0"
}

