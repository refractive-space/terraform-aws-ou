# AWS Organizations OU Terraform Module

[![Terraform Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/your-org/ou/aws)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Terraform Version](https://img.shields.io/badge/terraform-%3E%3D1.8.0-blue.svg)](https://www.terraform.io/)
[![AWS Provider](https://img.shields.io/badge/aws-%3E%3D5.0-orange.svg)](https://registry.terraform.io/providers/hashicorp/aws/latest)

A lightweight Terraform module for creating and managing AWS Organizations Organizational Units (OUs) with optional service control policies and tag policies.

## Features

- ✅ **Simple OU Creation** - Create organizational units with minimal configuration
- ✅ **Service Control Policies** - Attach SCPs for security guardrails and compliance
- ✅ **Tag Policies** - Enforce consistent tagging across your organization
- ✅ **Flexible Naming** - Customizable policy naming with prefix support
- ✅ **Input Validation** - Built-in validation for all inputs
- ✅ **Comprehensive Outputs** - Access all created resource IDs and ARNs

## Usage

### Basic Example

```hcl
module "development_ou" {
  source = "your-org/ou/aws"
  
  name      = "Development"
  parent_id = "r-1234567890abcdef0"  # Your root ID
  
  tags = {
    Environment = "Development"
    Team        = "Platform"
  }
}
```

### With Service Control Policy

```hcl
module "restricted_ou" {
  source = "your-org/ou/aws"
  
  name      = "Restricted Environment"
  parent_id = "r-1234567890abcdef0"
  
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
      }
    ]
  })
  
  tags = {
    Environment = "Restricted"
    Purpose     = "High-security workloads"
  }
}
```

### With Tag Policy

```hcl
module "compliance_ou" {
  source = "your-org/ou/aws"
  
  name      = "Compliance Environment"
  parent_id = "r-1234567890abcdef0"
  
  tag_policy = jsonencode({
    tags = {
      Environment = {
        tag_key = "Environment"
        tag_value = {
          "@@assign" = ["Production", "Staging", "Development"]
        }
        enforced_for = {
          "@@assign" = ["ec2:instance", "rds:db", "s3:bucket"]
        }
      }
    }
  })
  
  tags = {
    Environment = "Compliance"
    Purpose     = "Regulated workloads"
  }
}
```

### Complete Example

```hcl
module "production_ou" {
  source = "your-org/ou/aws"
  
  name          = "Production Environment"
  parent_id     = "r-1234567890abcdef0"
  policy_prefix = "prod"
  
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
            "aws:PrincipalTag/Role" = "Administrator"
          }
        }
      }
    ]
  })
  
  tag_policy = jsonencode({
    tags = {
      Environment = {
        tag_key = "Environment"
        tag_value = {
          "@@assign" = ["Production"]
        }
        enforced_for = {
          "@@assign" = ["ec2:instance", "rds:db", "s3:bucket"]
        }
      }
    }
  })
  
  tags = {
    Environment    = "Production"
    BusinessUnit   = "Engineering"
    ManagedBy      = "Terraform"
  }
}
```

## Examples

See the [examples](./examples) directory for more comprehensive usage patterns:

- [Basic](./examples/basic) - Simple OU creation
- [With SCP](./examples/with-scp) - OU with service control policy
- [With Tag Policy](./examples/with-tag-policy) - OU with tag enforcement
- [Complete](./examples/complete) - Full-featured example with both policies

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_organizations_organizational_unit.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit) | resource |
| [aws_organizations_policy.service_control_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy) | resource |
| [aws_organizations_policy.tag_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy) | resource |
| [aws_organizations_policy_attachment.service_control_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment) | resource |
| [aws_organizations_policy_attachment.tag_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the organizational unit to create | `string` | n/a | yes |
| <a name="input_parent_id"></a> [parent\_id](#input\_parent\_id) | The parent organizational unit ID or root ID where this OU will be created | `string` | n/a | yes |
| <a name="input_policy_prefix"></a> [policy\_prefix](#input\_policy\_prefix) | Optional prefix for policy names. If empty, only the normalized OU name will be used | `string` | `""` | no |
| <a name="input_service_control_policy"></a> [service\_control\_policy](#input\_service\_control\_policy) | JSON content for the service control policy. If empty, no SCP will be created | `string` | `""` | no |
| <a name="input_tag_policy"></a> [tag\_policy](#input\_tag\_policy) | JSON content for the tag policy. If empty, no tag policy will be created | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the organizational unit |
| <a name="output_id"></a> [id](#output\_id) | The ID of the organizational unit |
| <a name="output_name"></a> [name](#output\_name) | The name of the organizational unit |
| <a name="output_policy_prefix"></a> [policy\_prefix](#output\_policy\_prefix) | The computed policy prefix used for naming policies |
| <a name="output_service_control_policy_id"></a> [service\_control\_policy\_id](#output\_service\_control\_policy\_id) | The ID of the service control policy, if created |
| <a name="output_tag_policy_id"></a> [tag\_policy\_id](#output\_tag\_policy\_id) | The ID of the tag policy, if created |

## Prerequisites

Before using this module, ensure you have:

1. **AWS Organizations enabled** in your AWS account
2. **Appropriate IAM permissions** for Organizations operations:
   - `organizations:CreateOrganizationalUnit`
   - `organizations:CreatePolicy`
   - `organizations:AttachPolicy`
   - `organizations:TagResource`
3. **Service Control Policies enabled** (if using SCPs)
4. **Tag Policies enabled** (if using tag policies)

## Input Validation

This module includes comprehensive input validation:

- **OU Name**: Must be 1-68 characters
- **Parent ID**: Must be valid AWS Organizations root ID (`r-*`) or OU ID (`ou-*`)
- **Policy Content**: Must be valid JSON or empty string
- **Tags**: Must be valid key-value pairs

## Policy Naming

Policies are automatically named using the following convention:
- Service Control Policy: `{policy_prefix}-{normalized_ou_name}-scp`
- Tag Policy: `{policy_prefix}-{normalized_ou_name}-tp`

Where:
- `policy_prefix` is optional and defaults to empty
- `normalized_ou_name` is the OU name converted to lowercase with spaces replaced by hyphens

## Common Use Cases

### 1. Development/Staging/Production Separation
Create separate OUs for different environments with appropriate policies.

### 2. Security Compliance
Use SCPs to enforce security guardrails and prevent unauthorized actions.

### 3. Cost Management
Implement tag policies to ensure proper cost allocation and resource tracking.

### 4. Regulatory Compliance
Combine SCPs and tag policies to meet regulatory requirements.

## Contributing

Contributions are welcome! Please read the contributing guidelines and submit pull requests to the main branch.

## License

This module is licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.

## Support

For issues and questions:
- Check the [examples](./examples) directory
- Review the [Terraform AWS Organizations documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit)
- Open an issue in this repository