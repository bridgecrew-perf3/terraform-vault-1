data "terraform_remote_state" "admin" {
  backend = "gcs"

  config = {
    bucket      = "terraform-state-japneet-arctiq"
    prefix      = "3a-create-dynamic-secrets"
    credentials = "serviceaccount-auth.json"
  }
}

data "vault_aws_access_credentials" "creds" {
  backend = data.terraform_remote_state.admin.outputs.backend
  role    = data.terraform_remote_state.admin.outputs.role
}

#This will generate new IAM user using vault dynamic secrets
provider "aws" {
  region     = "us-east-1"
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
}

#Fetch latest amzn2 ami
data "aws_ami" "ami" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

# Create AWS EC2 Instance
resource "aws_instance" "test" {
  ami           = data.aws_ami.ami.id
  instance_type = "t2.nano"

  tags = {
    Name = "test"
  }
}