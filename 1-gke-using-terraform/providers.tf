provider "google" {
  credentials = file("serviceaccount-auth.json")
  project     = var.project_id
  region      = var.region
}