# The ARN of the created organizational unit
output "arn" {
  description = "The ARN of the organizational unit"
  value       = aws_organizations_organizational_unit.this.arn
}

# The ID of the created organizational unit
output "id" {
  description = "The ID of the organizational unit"
  value       = aws_organizations_organizational_unit.this.id
}

# The name of the organizational unit (passed through from input)
output "name" {
  description = "The name of the organizational unit"
  value       = var.name
}

# The computed policy prefix used for naming policies
output "policy_prefix" {
  description = "The computed policy prefix used for naming policies"
  value       = local.policy_prefix
}

# The ID of the service control policy (if created)
output "service_control_policy_id" {
  description = "The ID of the service control policy, if created"
  value       = local.include_service_control_policy ? aws_organizations_policy.service_control_policy[0].id : null
}

# The ID of the tag policy (if created)
output "tag_policy_id" {
  description = "The ID of the tag policy, if created"
  value       = local.include_tag_policy ? aws_organizations_policy.tag_policy[0].id : null
}
