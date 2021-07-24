terraform {
  backend "gcs" {
    credentials = "serviceaccount-auth.json"
    bucket      = "terraform-state-japneet-arctiq"
    prefix      = "3a-create-dynamic-secrets"
  }
}