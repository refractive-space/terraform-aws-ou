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

# Create an organizational unit with both SCP and tag policy
module "production_ou" {
  source = "../../"

  name         = "Production Environment"
  parent_id    = data.aws_organizations_organization.current.roots[0].id
  policy_prefix = "prod"

  # Service Control Policy for production security
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
          "s3:DeleteBucket",
          "iam:DeleteRole",
          "iam:DeleteUser",
          "iam:DeletePolicy"
        ]
        Resource = "*"
        Condition = {
          StringNotEquals = {
            "aws:PrincipalTag/Role" = "Administrator"
          }
        }
      },
      {
        Effect = "Deny"
        Action = [
          "organizations:*",
          "account:*"
        ]
        Resource = "*"
      }
    ]
  })

  # Tag Policy for production compliance
  tag_policy = jsonencode({
    tags = {
      Environment = {
        tag_key = "Environment"
        tag_value = {
          "@@assign" = ["Production"]
        }
        enforced_for = {
          "@@assign" = [
            "ec2:instance",
            "rds:db",
            "s3:bucket",
            "lambda:function",
            "ecs:cluster",
            "eks:cluster"
          ]
        }
      }
      CostCenter = {
        tag_key = "CostCenter"
        tag_value = {
          "@@assign" = ["Engineering", "Operations", "Security"]
        }
        enforced_for = {
          "@@assign" = [
            "ec2:instance",
            "rds:db",
            "s3:bucket",
            "lambda:function",
            "ecs:cluster",
            "eks:cluster"
          ]
        }
      }
      Owner = {
        tag_key = "Owner"
        tag_value = {
          "@@assign" = [".*"]
        }
        enforced_for = {
          "@@assign" = [
            "ec2:instance",
            "rds:db",
            "s3:bucket",
            "lambda:function",
            "ecs:cluster",
            "eks:cluster"
          ]
        }
      }
      BackupRequired = {
        tag_key = "BackupRequired"
        tag_value = {
          "@@assign" = ["true", "false"]
        }
        enforced_for = {
          "@@assign" = [
            "ec2:instance",
            "rds:db",
            "s3:bucket"
          ]
        }
      }
    }
  })

  tags = {
    Environment    = "Production"
    Purpose        = "Production workloads"
    Compliance     = "SOC2"
    BusinessUnit   = "Engineering"
    ManagedBy      = "Terraform"
  }
}