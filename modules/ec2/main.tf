resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  iam_instance_profile   = var.instance_profile_name
  vpc_security_group_ids = [var.sg_id]

  tags = var.tags

  user_data = <<-EOF
    #!/bin/bash
    yum install -y amazon-ssm-agent
    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent
  EOF

  metadata_options {
    http_tokens = "required"
  }

  lifecycle {
    prevent_destroy = false
  }
}
