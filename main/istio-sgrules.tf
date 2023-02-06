
/*
Istio required SG rules
Source: https://istio.io/latest/docs/ops/deployment/requirements/

*/


### Nodes to Controlplane

resource "aws_security_group_rule" "istio_nodes_to_controlplane_envoy_outbound" {
  type = "ingress"

  description = "Envoy outbound"
  from_port   = "15001"
  to_port     = "15001"
  protocol    = "tcp"

  security_group_id        = var.cluster_security_group_id
  source_security_group_id = var.node_security_group_id
}

resource "aws_security_group_rule" "istio_nodes_to_controlplane_envoy_inbound" {
  type = "ingress"

  description = "Envoy inbound"
  from_port   = "15006"
  to_port     = "15006"
  protocol    = "tcp"

  security_group_id        = var.cluster_security_group_id
  source_security_group_id = var.node_security_group_id
}

resource "aws_security_group_rule" "istio_nodes_to_controlplane_hbone_mtls" {
  type = "ingress"

  description = "HBONE mTLS tunnel port"
  from_port   = "15008"
  to_port     = "15008"
  protocol    = "tcp"

  security_group_id        = var.cluster_security_group_id
  source_security_group_id = var.node_security_group_id
}

resource "aws_security_group_rule" "istio_nodes_to_controlplane_hbone_secure" {
  type = "ingress"

  description = "HBONE port for secure networks"
  from_port   = "15009"
  to_port     = "15009"
  protocol    = "tcp"

  security_group_id        = var.cluster_security_group_id
  source_security_group_id = var.node_security_group_id
}

resource "aws_security_group_rule" "istio_nodes_to_controlplane_merged_prometheus_telemetry" {
  type = "ingress"

  description = "Merged Prometheus telemetry"
  from_port   = "15020"
  to_port     = "15020"
  protocol    = "tcp"

  security_group_id        = var.cluster_security_group_id
  source_security_group_id = var.node_security_group_id
}

resource "aws_security_group_rule" "istio_nodes_to_controlplane_health_checks" {
  type = "ingress"

  description = "Health checks"
  from_port   = "15021"
  to_port     = "15021"
  protocol    = "tcp"

  security_group_id        = var.cluster_security_group_id
  source_security_group_id = var.node_security_group_id
}

resource "aws_security_group_rule" "istio_nodes_to_controlplane_envoy_prometheus_telemetry" {
  type = "ingress"

  description = "Envoy Prometheus telemetry"
  from_port   = "15090"
  to_port     = "15090"
  protocol    = "tcp"

  security_group_id        = var.cluster_security_group_id
  source_security_group_id = var.node_security_group_id
}




### Controlplane to Nodes


resource "aws_security_group_rule" "istio_controlplane_to_nodes_webhook_container" {
  type = "ingress"

  description = "Webhook container port forwarded from 443"
  from_port   = "15017"
  to_port     = "15017"
  protocol    = "tcp"

  security_group_id        = var.node_security_group_id
  source_security_group_id = var.cluster_security_group_id
}


resource "aws_security_group_rule" "istio_controlplane_to_nodes_monitoring" {
  type = "ingress"

  description = "Control plane monitoring"
  from_port   = "15014"
  to_port     = "15014"
  protocol    = "tcp"

  security_group_id        = var.node_security_group_id
  source_security_group_id = var.cluster_security_group_id
}

resource "aws_security_group_rule" "istio_controlplane_to_nodes_xda_tls" {
  type = "ingress"

  description = "XDS and CA services TLS and mTLS"
  from_port   = "15012"
  to_port     = "15012"
  protocol    = "tcp"

  security_group_id        = var.node_security_group_id
  source_security_group_id = var.cluster_security_group_id
}

resource "aws_security_group_rule" "istio_controlplane_to_nodes_xda_plain" {
  type = "ingress"

  description = "XDS and CA services Plaintext"
  from_port   = "15010"
  to_port     = "15010"
  protocol    = "tcp"

  security_group_id        = var.node_security_group_id
  source_security_group_id = var.cluster_security_group_id
}

resource "aws_security_group_rule" "istio_controlplane_to_nodes_debug" {
  type = "ingress"

  description = "Debug interface "
  from_port   = "8080"
  to_port     = "8080"
  protocol    = "tcp"

  security_group_id        = var.node_security_group_id
  source_security_group_id = var.cluster_security_group_id
}

resource "aws_security_group_rule" "istio_controlplane_to_nodes_webhook_svc" {
  type = "ingress"

  description = "Webhooks service port"
  from_port   = "443"
  to_port     = "443"
  protocol    = "tcp"

  security_group_id        = var.node_security_group_id
  source_security_group_id = var.cluster_security_group_id
}