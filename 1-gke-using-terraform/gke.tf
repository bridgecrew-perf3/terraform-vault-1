# GKE cluster
resource "google_container_cluster" "gkecluster" {
  name     = "${var.project_id}-cluster"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

# Node Pool
resource "google_container_node_pool" "workernodes" {
  name       = "${google_container_cluster.gkecluster.name}-node-pool"
  cluster    = google_container_cluster.gkecluster.name
  location   = var.region
  node_count = var.gke_worker_nodes_per_zone

  node_config {
    image_type = "COS"
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
    }

    machine_type = var.machine_type
    tags         = ["worker-node", "${var.project_id}-cluster"]
  }
}

