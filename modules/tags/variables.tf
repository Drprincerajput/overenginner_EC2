variable "environment" {
  type        = string
  description = "Environment like dev, prod, staging"
}

variable "project" {
  type        = string
  description = "Project name"
}

variable "owner" {
  type        = string
  description = "Who owns this resource"
}

variable "additional_tags" {
  type        = map(string)
  default     = {}
  description = "Any extra tags to merge"
}
