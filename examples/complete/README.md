# Complete Example

This example demonstrates the full capabilities of the AWS Organizations OU module with both service control policy and tag policy.

## What this example does

- Creates an organizational unit named "Production Environment"
- Uses a custom policy prefix "prod" for policy naming
- Attaches a comprehensive service control policy that:
  - Allows all actions by default
  - Denies destructive actions unless performed by administrators
  - Blocks all Organizations and Account management actions
- Attaches a tag policy that enforces:
  - `Environment` tag must be "Production"
  - `CostCenter` tag with predefined values
  - `Owner` tag with any value
  - `BackupRequired` tag with true/false values
- Applies comprehensive tagging to the OU itself

## Service Control Policy Details

The SCP implements production-grade security controls:
- **Destructive Action Protection**: Prevents accidental deletion of critical resources
- **Privilege Escalation Prevention**: Blocks Organizations and Account management
- **Role-Based Exceptions**: Allows administrators to perform restricted actions
- **Defense in Depth**: Multiple layers of protection

## Tag Policy Details

The tag policy enforces organizational governance:
- **Environment Consistency**: Forces "Production" environment tag
- **Cost Management**: Requires cost center assignment
- **Ownership Tracking**: Ensures all resources have owners
- **Backup Requirements**: Mandates backup decision for data resources

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Requirements

- AWS CLI configured with appropriate permissions
- Terraform >= 1.8.0
- AWS Organizations enabled with both SCP and Tag Policy features enabled
- Appropriate IAM permissions to create and attach both policy types

## Outputs

- `organizational_unit_id` - The ID of the created OU
- `organizational_unit_arn` - The ARN of the created OU
- `service_control_policy_id` - The ID of the attached SCP
- `tag_policy_id` - The ID of the attached tag policy
- `policy_prefix` - The computed policy prefix used for naming