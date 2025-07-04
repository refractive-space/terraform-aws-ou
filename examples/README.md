# Examples

This directory contains practical examples demonstrating various usage patterns of the AWS Organizations OU Terraform module.

## Available Examples

### [Basic](./basic/)
The simplest possible usage - creates an organizational unit with basic configuration and tags.

**Use case**: Quick setup for simple organizational structures.

### [With Service Control Policy](./with-scp/)
Demonstrates how to attach a service control policy that restricts certain actions.

**Use case**: Implementing security guardrails and compliance controls.

### [With Tag Policy](./with-tag-policy/)
Shows how to enforce consistent tagging across resources using tag policies.

**Use case**: Governance, cost management, and compliance requirements.

### [Complete](./complete/)
Full-featured example with both service control policy and tag policy, plus custom naming.

**Use case**: Production-ready organizational unit with comprehensive governance.

## Running the Examples

1. Choose the example that best fits your needs
2. Navigate to the example directory
3. Review the README.md for specific requirements
4. Run the standard Terraform workflow:

```bash
terraform init
terraform plan
terraform apply
```

## Prerequisites

All examples require:
- AWS CLI configured with appropriate permissions
- Terraform >= 1.8.0
- AWS Organizations enabled in your AWS account
- Appropriate IAM permissions for Organizations operations

Additional requirements for specific examples:
- **SCP examples**: Service Control Policies feature enabled
- **Tag policy examples**: Tag Policies feature enabled

## Customization

Each example can be customized by:
- Modifying the policy content to match your requirements
- Adjusting the organizational unit names and structure
- Changing the tags to fit your organizational standards
- Updating the parent_id to place OUs in different locations