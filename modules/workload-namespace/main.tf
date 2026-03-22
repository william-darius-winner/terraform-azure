resource "kubernetes_namespace_v1" "main" {
  metadata {
    name = var.namespace_name

    labels = {
      environment = var.environment
      managed-by  = "terraform"
      team        = var.team_name
    }
  }
}

resource "kubernetes_resource_quota_v1" "main" {
  metadata {
    name      = "quota-${var.namespace_name}"
    namespace = kubernetes_namespace_v1.main.metadata[0].name
  }

  spec {
    hard = {
      "requests.cpu"    = var.cpu_request_limit
      "requests.memory" = var.memory_request_limit
      "pods"            = var.max_pods
    }
  }
}

resource "kubernetes_limit_range_v1" "main" {
  metadata {
    name      = "limits-${var.namespace_name}"
    namespace = kubernetes_namespace_v1.main.metadata[0].name
  }

  spec {
    limit {
      type = "Container"

      default = {
        cpu    = "500m"
        memory = "256Mi"
      }

      default_request = {
        cpu    = "100m"
        memory = "128Mi"
      }
    }
  }
}
