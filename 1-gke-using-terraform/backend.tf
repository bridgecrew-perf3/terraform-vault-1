terraform {
  backend "gcs" {
    credentials = "key.json"
    bucket      = "terraform-state-japneet-arctiq"
    prefix      = "terraform/state"
  }
}