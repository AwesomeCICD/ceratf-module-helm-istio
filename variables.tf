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