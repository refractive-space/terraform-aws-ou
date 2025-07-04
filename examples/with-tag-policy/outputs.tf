output "organizational_unit_id" {
  description = "The ID of the created organizational unit"
  value       = module.compliance_ou.id
}

output "organizational_unit_arn" {
  description = "The ARN of the created organizational unit"
  value       = module.compliance_ou.arn
}

output "tag_policy_id" {
  description = "The ID of the tag policy"
  value       = module.compliance_ou.tag_policy_id
}