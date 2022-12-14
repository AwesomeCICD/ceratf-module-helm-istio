locals {
  target_domain_stringified = replace(var.target_domain, ".", "-")
}