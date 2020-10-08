# terraform-aws-iam-role

Terraform module to create IAM role with Instance profile.

Requires:

- terraform: `>= 0.12.0, < 0.14.0`
- provider aws: `>= 2.68, < 4.0`

[terraform registry](https://registry.terraform.io/modules/y-batsianouski/vpc/aws)

## Resources

This module can manage next resources:

* IAM role
* One or multiple inline policies
* One or multiple additional IAM policies can be created and attached to the IAM role
* One or multiple existed IAM policies can be attached to the IAM role
* IAM instance profile can be created

## Usage

```terraform

module "iam_role" {
  source = "y-batsianouski/iam-role/aws"

  name                    = "BackendApp"
  description             = "Iam role for backend application"
  create_instance_profile = true

  inline_policies = [
    {
      name   = "s3-access"
      policy = <<-EOF
      {
          "Version": "2012-10-17",
          "Statement": [
              {
                  "Sid": "VisualEditor0",
                  "Effect": "Allow",
                  "Action": [
                      "s3:GetAccessPoint",
                      "s3:PutAccountPublicAccessBlock",
                      "s3:GetAccountPublicAccessBlock",
                      "s3:ListAllMyBuckets",
                      "s3:ListAccessPoints",
                      "s3:ListJobs",
                      "s3:CreateJob"
                  ],
                  "Resource": "*"
              },
              {
                  "Sid": "VisualEditor1",
                  "Effect": "Allow",
                  "Action": "s3:*",
                  "Resource": [
                      "arn:aws:s3:::*",
                      "arn:aws:s3:*:083130986194:accesspoint/*",
                      "arn:aws:s3:*:083130986194:job/*"
                  ]
              },
              {
                  "Sid": "VisualEditor2",
                  "Effect": "Allow",
                  "Action": "s3:*",
                  "Resource": "arn:aws:s3:::*/*"
              }
          ]
      }
      EOF
    }
  ]
  policies = [
    {
      name_suffix = "sqs-access",
      description = "Access to SQS for backend app",
      policy      = file("${path.module}/sqs-access.json")
    }
  ]
  policies_attachements = ["arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"]

  tags = {
    app = "backend"
  }
}

```