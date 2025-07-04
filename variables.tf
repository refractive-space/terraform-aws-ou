# The name of the organizational unit
variable "name" {
  description = "The name of the organizational unit to create"
  type        = string
  
  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 68
    error_message = "OU name must be between 1 and 68 characters."
  }
}

# The parent organizational unit or root ID where this OU will be created
variable "parent_id" {
  description = "The parent organizational unit ID or root ID where this OU will be created"
  type        = string
  
  validation {
    condition     = can(regex("^(r-[0-9a-z]{4,32}|ou-[0-9a-z]{4,32}-[0-9a-z]{8,32})$", var.parent_id))
    error_message = "Parent ID must be a valid AWS Organizations root ID (r-) or organizational unit ID (ou-)."
  }
}

# Optional prefix for policy names to ensure uniqueness
variable "policy_prefix" {
  description = "Optional prefix for policy names. If empty, only the normalized OU name will be used"
  type        = string
  default     = ""
}

# JSON content for service control policy
variable "service_control_policy" {
  description = "JSON content for the service control policy. If empty, no SCP will be created"
  type        = string
  default     = ""
  
  validation {
    condition     = var.service_control_policy == "" || can(jsondecode(var.service_control_policy))
    error_message = "Service control policy must be valid JSON or empty string."
  }
}

# JSON content for tag policy
variable "tag_policy" {
  description = "JSON content for the tag policy. If empty, no tag policy will be created"
  type        = string
  default     = ""
  
  validation {
    condition     = var.tag_policy == "" || can(jsondecode(var.tag_policy))
    error_message = "Tag policy must be valid JSON or empty string."
  }
}

# Tags to apply to all resources
variable "tags" {
  description = "A map of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
