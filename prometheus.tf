# Split this out from main because it was so long

/*
resource "kubernetes_service_account_v1" "prometheus" {
  metadata {
    name      = "prometheus"
    namespace = "istio-system"
    labels = {
      app       = "prometheus"
      chart     = "prometheus-15.9.0"
      component = "server"
      heritage  = "Helm"
      release   = "prometheus"
    }
  }
}



resource "kubernetes_cluster_role_v1" "prometheus" {
  metadata {
    name = "prometheus"
    labels = {
      app       = "prometheus"
      chart     = "prometheus-15.9.0"
      component = "server"
      heritage  = "Helm"
      release   = "prometheus"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["nodes", "nodes/proxy", "nodes/metrics", "services", "endpoints", "pods", "ingresses", "configmaps"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["extensions", "networking.k8s.io"]
    resources  = ["ingresses/status", "ingresses"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    non_resource_urls = ["/metrics"]
    verbs             = ["get"]
  }
}

resource "kubernetes_cluster_role_binding_v1" "prometheus" {
  metadata {
    name = "prometheus"
    labels = {
      app       = "prometheus"
      chart     = "prometheus-15.9.0"
      component = "server"
      heritage  = "Helm"
      release   = "prometheus"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "prometheus"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "prometheus"
    namespace = "istio-system"
  }
}




resource "kubernetes_service_v1" "prometheus" {
  metadata {
    labels = {
      app       = "prometheus"
      chart     = "prometheus-15.9.0"
      component = "server"
      heritage  = "Helm"
      release   = "prometheus"
    }
    name      = "prometheus"
    namespace = "istio-system"
  }

  spec {
    port {
      name        = "http"
      port        = 9090
      protocol    = "TCP"
      target_port = 9090
    }
    selector = {
      app       = "prometheus"
      component = "server"
      release   = "prometheus"
    }
    session_affinity = "None"
    type             = "ClusterIP"
  }
}



resource "kubernetes_config_map_v1" "prometheus" {

  metadata {
    name      = "prometheus"
    namespace = "istio-system"
    labels = {
      app       = "prometheus"
      chart     = "prometheus-15.9.0"
      component = "server"
      heritage  = "Helm"
      release   = "prometheus"
    }
  }

  data = yamldecode(file("${path.module}/app-config/prometheus/configmap_data.yaml"))
}




resource "kubernetes_deployment_v1" "prometheus" {

  metadata {
    name      = "prometheus"
    namespace = "istio-system"
    labels = {
      app       = "prometheus"
      chart     = "prometheus-15.9.0"
      component = "server"
      heritage  = "Helm"
      release   = "prometheus"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app       = "prometheus"
        component = "server"
        release   = "prometheus"
      }
    }
    template {
      metadata {
        labels = {
          app                       = "prometheus"
          chart                     = "prometheus-15.9.0"
          component                 = "server"
          heritage                  = "Helm"
          release                   = "prometheus"
          "sidecar.istio.io/inject" = "false"
        }
      }


      spec {
        container {
          args              = ["--volume-dir=/etc/config", "--webhook-url=http://127.0.0.1:9090/-/reload"]
          image             = "jimmidyson/configmap-reload:v0.5.0"
          image_pull_policy = "IfNotPresent"
          name              = "prometheus-server-configmap-reload"
          volume_mount {
            mount_path = "/etc/config"
            name       = "config-volume"
            read_only  = "true"
          }
        }
        container {
          args = [
            "--storage.tsdb.retention.time=15d",
            "--config.file=/etc/config/prometheus.yml",
            "--storage.tsdb.path=/data",
            "--web.console.libraries=/etc/prometheus/console_libraries",
            "--web.console.templates=/etc/prometheus/consoles",
            "--web.enable-lifecycle",
            "--web.route-prefix=/",
            "--web.external-url=https://monitor.japac.circleci-labs.com/prometheus/"
          ]
          image             = "prom/prometheus:${var.prometheus_version}"
          image_pull_policy = "IfNotPresent"
          liveness_probe {
            failure_threshold = "3"
            http_get {
              path   = "/-/healthy"
              port   = "9090"
              scheme = "HTTP"
            }
            initial_delay_seconds = "30"
            period_seconds        = "15"
            success_threshold     = "1"
            timeout_seconds       = "10"
          }
          name = "prometheus-server"
          port {
            container_port = "9090"
          }
          readiness_probe {
            failure_threshold = "3"
            http_get {
              path   = "/-/ready"
              port   = "9090"
              scheme = "HTTP"
            }
            initial_delay_seconds = "0"
            period_seconds        = "5"
            success_threshold     = "1"
            timeout_seconds       = "4"
          }
          volume_mount {
            mount_path = "/etc/config"
            name       = "config-volume"
          }
          volume_mount {
            mount_path = "/data"
            name       = "storage-volume"
            sub_path   = ""
          }
        }
        dns_policy           = "ClusterFirst"
        enable_service_links = "true"
        host_network         = "false"
        security_context {
          fs_group        = "65534"
          run_as_group    = "65534"
          run_as_non_root = "true"
          run_as_user     = "65534"
        }
        service_account_name             = "prometheus"
        termination_grace_period_seconds = "300"
        volume {
          config_map {
            name = "prometheus"
          }
          name = "config-volume"
        }
        volume {
          empty_dir {}
          name = "storage-volume"
        }
      }
    }
  }
}
*/