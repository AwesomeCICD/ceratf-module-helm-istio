data "http" "prometheus_manifest" {
  url = "https://raw.githubusercontent.com/istio/istio/release-${var.istio_chart_version}/samples/addons/prometheus.yaml"

  request_headers = {
    Accept = "application/yaml"
  }
}