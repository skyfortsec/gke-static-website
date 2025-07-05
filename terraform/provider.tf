# Google Cloud provider configuration
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Kubernetes provider to interact with the GKE cluster
provider "kubernetes" {
  host                   = google_container_cluster.primary.endpoint
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  )
}

# Get authenticated account config for access token
data "google_client_config" "default" {}
