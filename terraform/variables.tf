variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "zone" {
  description = "GCP zone"
  type        = string
}

variable "cluster_name" {
  description = "GKE Cluster Name"
  type        = string
  default     = "gke-static-cluster"
}