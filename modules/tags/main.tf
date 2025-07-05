locals {
  default_tags = {
    environment = var.environment
    project     = var.project
    owner       = var.owner
    managed_by  = "terraform"
  }

  merged_tags = merge(local.default_tags, var.additional_tags)
}

output "tags" {
  value = local.merged_tags
}
