output "organizational_unit_id" {
  description = "The ID of the created organizational unit"
  value       = module.production_ou.id
}

output "organizational_unit_arn" {
  description = "The ARN of the created organizational unit"
  value       = module.production_ou.arn
}

output "service_control_policy_id" {
  description = "The ID of the service control policy"
  value       = module.production_ou.service_control_policy_id
}

output "tag_policy_id" {
  description = "The ID of the tag policy"
  value       = module.production_ou.tag_policy_id
}

output "policy_prefix" {
  description = "The policy prefix used for naming"
  value       = module.production_ou.policy_prefix
}