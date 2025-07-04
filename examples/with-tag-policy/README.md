# Tag Policy Example

This example demonstrates how to create an organizational unit with a tag policy that enforces required tags on resources.

## What this example does

- Creates an organizational unit named "Compliance Environment"
- Attaches a tag policy that enforces:
  - `Environment` tag with allowed values: Production, Staging, Development
  - `CostCenter` tag with allowed values: Engineering, Marketing, Sales, Operations
  - `Owner` tag with any value (regex pattern allows all)
- Applies these requirements to EC2 instances, RDS databases, and S3 buckets

## Tag Policy Details

The tag policy in this example:
- Ensures consistent tagging across the organization
- Helps with cost allocation and resource management
- Supports compliance requirements for resource governance
- Uses AWS Organizations tag policy syntax with `@@assign` operators

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Requirements

- AWS CLI configured with appropriate permissions
- Terraform >= 1.8.0
- AWS Organizations enabled with Tag Policies feature enabled
- Appropriate IAM permissions to create and attach tag policies

## Outputs

- `organizational_unit_id` - The ID of the created OU
- `organizational_unit_arn` - The ARN of the created OU
- `tag_policy_id` - The ID of the attached tag policy