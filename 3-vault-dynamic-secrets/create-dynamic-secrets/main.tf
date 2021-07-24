resource "vault_aws_secret_backend" "aws" {
  access_key                = var.aws_access_key
  secret_key                = var.aws_secret_key
  path                      = "aws"
  default_lease_ttl_seconds = "120"
  max_lease_ttl_seconds     = "240"
}

resource "vault_aws_secret_backend_role" "terraform" {
  backend         = vault_aws_secret_backend.aws.path
  name            = "terraform-role"
  credential_type = "iam_user"

  policy_document = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "ec2:*",
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": "iam:*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}