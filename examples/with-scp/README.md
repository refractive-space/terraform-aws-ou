# Service Control Policy Example

This example demonstrates how to create an organizational unit with a service control policy (SCP) that restricts certain actions.

## What this example does

- Creates an organizational unit named "Restricted Environment"
- Attaches a service control policy that:
  - Allows all actions by default
  - Denies destructive actions (terminate instances, delete RDS, delete S3 buckets)
  - Exception: allows these actions for principals tagged with `Environment=Production`

## Service Control Policy Details

The SCP in this example implements a "guardrails" approach:
- Prevents accidental deletion of critical resources
- Uses conditional logic based on principal tags
- Maintains least-privilege access principles

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Requirements

- AWS CLI configured with appropriate permissions
- Terraform >= 1.8.0
- AWS Organizations enabled with Service Control Policies feature enabled
- Appropriate IAM permissions to create and attach SCPs

## Outputs

- `organizational_unit_id` - The ID of the created OU
- `organizational_unit_arn` - The ARN of the created OU
- `service_control_policy_id` - The ID of the attached SCP