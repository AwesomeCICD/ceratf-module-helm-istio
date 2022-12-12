
/*
Istio required SG rules
Source: https://istio.io/latest/docs/ops/deployment/requirements/

VS code regex to generate these from docs:

(\d+?)\s+(\w+)\s+?(.*)\s(N|Y).*$
{description = "$3",from_port = "$1",to_port = "$1",protocol = "tcp"},
*/


resource "aws_security_group_rule" "istio_controlplane_to_nodes" {
  description = each.value["description"]
  type        = "ingress"
  from_port   = each.value["from_port"]
  to_port     = each.value["to_port"]
  protocol    = each.value["protocol"]

  security_group_id = var.node_security_group_id

  for_each = toset([
    { description = "Webhooks service port", from_port = "443", to_port = "443", protocol = "tcp" },
    { description = "Debug interface ", from_port = "8080", to_port = "8080", protocol = "tcp" },
    { description = "XDS and CA services Plaintext", from_port = "15010", to_port = "15010", protocol = "tcp" },
    { description = "XDS and CA services TLS and mTLS", from_port = "15012", to_port = "15012", protocol = "tcp" },
    { description = "Control plane monitoring", from_port = "15014", to_port = "15014", protocol = "tcp" },
    { description = "Webhook container port, forwarded from 443", from_port = "15017", to_port = "15017", protocol = "tcp" }
  ])
}

resource "aws_security_group_rule" "istio_nodes_to_controlplane" {
  description = each.value["description"]
  type        = "ingress"
  from_port   = each.value["from_port"]
  to_port     = each.value["to_port"]
  protocol    = each.value["protocol"]

  security_group_id = var.controlplane_security_group_id

  for_each = toset([
    { description = "Envoy outbound", from_port = "15001", to_port = "15001", protocol = "tcp" },
    { description = "Envoy inbound", from_port = "15006", to_port = "15006", protocol = "tcp" },
    { description = "HBONE mTLS tunnel port", from_port = "15008", to_port = "15008", protocol = "tcp" },
    { description = "HBONE port for secure networks", from_port = "15009", to_port = "15009", protocol = "tcp" },
    { description = "Merged Prometheus telemetry from Istio agent, Envoy, and application", from_port = "15020", to_port = "15020", protocol = "tcp" },
    { description = "Health checks", from_port = "15021", to_port = "15021", protocol = "tcp" },
    { description = "Envoy Prometheus telemetry", from_port = "15090", to_port = "15090", protocol = "tcp" }
  ])
}