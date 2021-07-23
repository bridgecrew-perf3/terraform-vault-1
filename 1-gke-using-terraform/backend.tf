terraform {
  backend "gcs" {
    credentials = "serviceaccount-auth.json"
    bucket      = "terraform-state-japneet-arctiq"
    prefix      = "terraform/state"
  }
}