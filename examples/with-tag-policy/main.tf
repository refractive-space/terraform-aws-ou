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

# Create an organizational unit with a tag policy
module "compliance_ou" {
  source = "../../"

  name      = "Compliance Environment"
  parent_id = data.aws_organizations_organization.current.roots[0].id

  # Tag Policy that enforces required tags
  tag_policy = jsonencode({
    tags = {
      Environment = {
        tag_key = "Environment"
        tag_value = {
          "@@assign" = ["Production", "Staging", "Development"]
        }
        enforced_for = {
          "@@assign" = [
            "ec2:instance",
            "rds:db",
            "s3:bucket"
          ]
        }
      }
      CostCenter = {
        tag_key = "CostCenter"
        tag_value = {
          "@@assign" = ["Engineering", "Marketing", "Sales", "Operations"]
        }
        enforced_for = {
          "@@assign" = [
            "ec2:instance",
            "rds:db",
            "s3:bucket"
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
            "s3:bucket"
          ]
        }
      }
    }
  })

  tags = {
    Environment = "Compliance"
    Purpose     = "Regulated workloads"
  }
}