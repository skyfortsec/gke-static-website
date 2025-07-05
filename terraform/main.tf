resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false

  ip_allocation_policy {}
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "default-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

resource "kubernetes_namespace" "web" {
  metadata {
    name = "web"
  }
}

resource "kubernetes_config_map" "site_files" {
  metadata {
    name      = "site-config"
    namespace = kubernetes_namespace.web.metadata[0].name
  }

  data = {
    "index.html" = file("${path.module}/../website/index.html")
    "style.css"  = file("${path.module}/../website/style.css")
    "script.js"  = file("${path.module}/../website/script.js")
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.web.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"

          port {
            container_port = 80
          }

          volume_mount {
            name       = "site-content"
            mount_path = "/usr/share/nginx/html"
            read_only  = true
          }
        }

        volume {
          name = "site-content"

          config_map {
            name = kubernetes_config_map.site_files.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx-service"
    namespace = kubernetes_namespace.web.metadata[0].name
  }

  spec {
    selector = {
      app = "nginx"
    }

    type = "LoadBalancer"

    port {
      port        = 80
      target_port = 80
    }
  }
}