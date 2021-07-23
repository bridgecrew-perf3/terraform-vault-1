output "region" {
  value       = var.region
  description = "Region to be used by gcloud"
}

output "gke_cluster_name" {
  value       = google_container_cluster.gkecluster.name
  description = "GKE Cluster Name to be used by gcloud"
}
