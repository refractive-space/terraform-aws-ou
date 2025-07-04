# Basic Example

This example demonstrates the most basic usage of the AWS Organizations OU module.

## What this example does

- Creates a simple organizational unit named "Development"
- Attaches it to the organization root
- Applies basic tags

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Requirements

- AWS CLI configured with appropriate permissions
- Terraform >= 1.8.0
- AWS Organizations enabled in your AWS account

## Outputs

- `organizational_unit_id` - The ID of the created OU
- `organizational_unit_arn` - The ARN of the created OU