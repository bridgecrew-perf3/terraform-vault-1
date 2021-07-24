variable "name" { default = "dynamic-aws-creds-operator" }
variable "region" { default = "us-east-1" }
variable "path" { default = "../vault-admin-workspace/terraform.tfstate" }
variable "ttl" { default = "1" }