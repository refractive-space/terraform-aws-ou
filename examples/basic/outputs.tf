output "organizational_unit_id" {
  description = "The ID of the created organizational unit"
  value       = module.development_ou.id
}

output "organizational_unit_arn" {
  description = "The ARN of the created organizational unit"
  value       = module.development_ou.arn
}