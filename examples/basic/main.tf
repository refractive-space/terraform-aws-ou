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

# Create a basic organizational unit
module "development_ou" {
  source = "../../"

  name      = "Development"
  parent_id = data.aws_organizations_organization.current.roots[0].id

  tags = {
    Environment = "Development"
    Team        = "Platform"
  }
}