apiVersion: kiali.io/v1alpha1
kind: Kiali
metadata:
  name: kiali
  namespace: ${istio_namespace}
spec:
  auth:
    strategy: ${auth_strategy}
  deployment:
    accessible_namespaces:
      - '**'
  server:
    web_root: "/kiali"
  external_services:
    istio:
      component_status:
        components:
        - app_label: "istiod"
          is_core: true
          is_proxy: false
        - app_label: "istio-ingressgateway"
          is_core: true
          is_proxy: true
          namespace: istio-ingress
        - app_label: "istio-egress"
          is_core: false
          is_proxy: true
          # default: namespace is undefined
          namespace: istio-system
        enabled: true
    grafana:
      url: http://grafana:3000
      dashboards:
      - name: "Istio Service Dashboard"
        variables:
          namespace: "var-namespace"
          service: "var-service"
      - name: "Istio Workload Dashboard"
        variables:
          namespace: "var-namespace"
          workload: "var-workload"
      - name: "Istio Mesh Dashboard"
      - name: "Istio Control Plane Dashboard"
      - name: "Istio Performance Dashboard"
      - name: "Istio Wasm Extension Dashboard"
    prometheus:
      url: http://prometheus-server:80
    tracing:
        # Enabled by default. Kiali will anyway fallback to disabled if
        # Jaeger is unreachable.
        enabled: true
        # Jaeger service name is "tracing" and is in the "telemetry" namespace.
        # Make sure the URL you provide corresponds to the non-GRPC enabled endpoint
        # if you set "use_grpc" to false.
        in_cluster_url: "http://jaeger-allinone-query.istio-system:16685/"
        use_grpc: true
        # Public facing URL of Jaeger
        url: "/jaeger"
