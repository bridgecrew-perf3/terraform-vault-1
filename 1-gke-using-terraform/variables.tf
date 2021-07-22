variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "gke_worker_nodes" {
  default     = 1
  description = "number of gke worker nodes"
}

variable "machine_type" {
  default     = "e2-standard-2"
  description = "type of gke worker nodes"
}