variable "vpc_id" {
  description = "VPC ID where SG will be created"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for SG name"
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}
