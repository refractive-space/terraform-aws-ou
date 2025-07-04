output "organizational_unit_id" {
  description = "The ID of the created organizational unit"
  value       = module.restricted_ou.id
}

output "organizational_unit_arn" {
  description = "The ARN of the created organizational unit"
  value       = module.restricted_ou.arn
}

output "service_control_policy_id" {
  description = "The ID of the service control policy"
  value       = module.restricted_ou.service_control_policy_id
}