terraform {
  required_version = ">= 1.8.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Get the AWS Organizations root ID
data "aws_organizations_organization" "current" {}

# Create an organizational unit with a service control policy
module "restricted_ou" {
  source = "../../"

  name      = "Restricted Environment"
  parent_id = data.aws_organizations_organization.current.roots[0].id

  # Service Control Policy that restricts certain actions
  service_control_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "*"
        Resource = "*"
      },
      {
        Effect = "Deny"
        Action = [
          "ec2:TerminateInstances",
          "rds:DeleteDBInstance",
          "s3:DeleteBucket"
        ]
        Resource = "*"
        Condition = {
          StringNotEquals = {
            "aws:PrincipalTag/Environment" = "Production"
          }
        }
      }
    ]
  })

  tags = {
    Environment = "Restricted"
    Purpose     = "High-security workloads"
  }
}