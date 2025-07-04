# Local values for conditional logic and naming conventions
locals {
  # Determine whether to create service control policy based on non-empty content
  include_service_control_policy = var.service_control_policy != ""
  
  # Determine whether to create tag policy based on non-empty content
  include_tag_policy             = var.tag_policy != ""
  
  # Normalize OU name for consistent naming (lowercase, spaces to hyphens)
  normalised_name                = replace(lower(var.name), " ", "-")
  
  # Generate policy prefix by combining user prefix with normalized name
  # Handle edge cases where prefix might be empty or contain double hyphens
  policy_prefix                  = trimprefix(replace("${var.policy_prefix}-${local.normalised_name}", "--", "-"), "-")
}

# Create the organizational unit with the specified name and parent
resource "aws_organizations_organizational_unit" "this" {
  name      = var.name
  parent_id = var.parent_id
}

# Create service control policy if content is provided
resource "aws_organizations_policy" "service_control_policy" {
  content = var.service_control_policy
  count   = local.include_service_control_policy ? 1 : 0
  name    = "${local.policy_prefix}-scp"
  type    = "SERVICE_CONTROL_POLICY"
  tags    = var.tags
}

# Attach service control policy to the organizational unit
resource "aws_organizations_policy_attachment" "service_control_policy" {
  count     = local.include_service_control_policy ? 1 : 0
  policy_id = aws_organizations_policy.service_control_policy[count.index].id
  target_id = aws_organizations_organizational_unit.this.id
}

# Create tag policy if content is provided
resource "aws_organizations_policy" "tag_policy" {
  content = var.tag_policy
  count   = local.include_tag_policy ? 1 : 0
  name    = "${local.policy_prefix}-tp"
  type    = "TAG_POLICY"
  tags    = var.tags
}

# Attach tag policy to the organizational unit
resource "aws_organizations_policy_attachment" "tag_policy" {
  count     = local.include_tag_policy ? 1 : 0
  policy_id = aws_organizations_policy.tag_policy[count.index].id
  target_id = aws_organizations_organizational_unit.this.id
}
