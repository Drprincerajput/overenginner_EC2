variable "ami_id" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "name_prefix" {}
variable "instance_profile_name" {}
variable "sg_id" {
  type        = string
  description = "Security group ID to attach to EC2"
}
variable "tags" {
  type = map(string)
}