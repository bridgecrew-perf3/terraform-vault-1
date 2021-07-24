terraform {
  backend "gcs" {
    credentials = "serviceaccount-auth.json"
    bucket      = "terraform-state-japneet-arctiq"
    prefix      = "1-gke-using-terraform"
  }
}