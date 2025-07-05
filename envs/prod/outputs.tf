output "ami_id_from_ssm" {
  value     = module.ami_id.value
  sensitive = true
}
