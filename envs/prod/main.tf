module "vpc" {
  source             = "../../modules/vpc"
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  availability_zone  = "us-east-1a"
  name_prefix        = "oe-prod"
  tags               = module.tags.tags
}

module "ec2" {
  source                = "../../modules/ec2"
  ami_id                = module.ami_id.value
  instance_type         = module.instance_type.value
  subnet_id             = module.vpc.subnet_id
  name_prefix           = "oe-prod"
  instance_profile_name = aws_iam_instance_profile.ssm.name
  sg_id                 = module.ec2_sg.security_group_id
  tags                  = module.tags.tags
}

resource "aws_iam_role" "ssm" {
  name = "oe-ssm-role-prod"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm" {
  name = "oe-ssm-profile-prod"
  role = aws_iam_role.ssm.name
}

module "ec2_sg" {
  source = "../../modules/sg"
  vpc_id = module.vpc.vpc_id

  name_prefix = "oe-prod"
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] # Temporary — consider using SSM only in prod
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  tags = module.tags.tags
}

module "tags" {
  source      = "../../modules/tags"
  environment = "prod"
  project     = "ec2-oe"
  owner       = "prince"
  additional_tags = {
    team = "infra"
  }
}

module "ami_id" {
  source = "../../modules/ssmps"
  name   = "/ec2-oe/prod/ami_id"
}

module "instance_type" {
  source = "../../modules/ssmps"
  name   = "/ec2-oe/prod/instance_type"
}
