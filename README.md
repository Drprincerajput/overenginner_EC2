```markdown

# Overengineered EC2 with Terraform

This project provisions an EC2 instance on AWS using a fully modular, parameterized, and environment-aware Terraform setup. It demonstrates real-world infrastructure practices including remote state, workspaces, IAM roles, parameter store, and CI/CD integration with GitHub Actions.

## Features

- Infrastructure-as-Code with Terraform
- Modular design (VPC, EC2, SG, IAM, Tags, SSM Parameter Store)
- Remote state using S3 and DynamoDB
- Environment-specific configurations (`dev`, `prod`)
- EC2 access via SSM only (no SSH key pairs)
- CI/CD pipeline with GitHub Actions (fmt, validate, plan, and manual apply)

## Directory Structure

```

ec2-oe-project/
├── .github/workflows/terraform.yml   # CI/CD pipeline
├── envs/                             # Environment-specific configs
│   ├── dev/
│   │   ├── backend.tf
│   │   ├── dev.backend.tfvars
│   │   ├── main.tf
│   │   └── outputs.tf
│   └── prod/
│       ├── backend.tf
│       ├── prod.backend.tfvars
│       ├── main.tf
│       └── outputs.tf
├── modules/                          # Reusable modules
│   ├── ec2/
│   ├── iam/
│   ├── sg/
│   ├── ssmps/
│   ├── tags/
│   └── vpc/
├── scripts/
│   ├── bootstrap.sh                  # Creates required SSM parameters
│   └── destroy-everything.sh         # Destroys all infra, state, parameters
├── init-backend.sh                   # Initializes Terraform backend for given env
├── backend.tf                        # Placeholder (required for per-env backend)
├── provider.tf
├── versions.tf
└── README.md

```

## Prerequisites

- Terraform 1.5+
- AWS CLI configured (`aws configure`)
- Valid AWS IAM credentials with permissions for EC2, IAM, SSM, S3, and DynamoDB

## Setup Instructions

### 1. Bootstrap Backend Infra (One-Time)

```bash
aws s3 mb s3://ec2-oe-terraform-state-prince --region us-east-1

aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

### 2. Initialize and Apply (Dev Environment)

```bash
./scripts/bootstrap.sh              # Creates required SSM parameters
./init-backend.sh dev              # Initializes backend for dev
cd envs/dev
terraform plan
terraform apply
```

### 3. Apply for Production

```bash
./init-backend.sh prod
cd envs/prod
terraform plan
terraform apply
```

### 4. Clean Up (Destroy Everything)

```bash
./scripts/destroy-everything.sh
```

## CI/CD Pipeline

This repo includes a GitHub Actions pipeline that:

- Runs `terraform fmt`, `validate`, and `plan` on every push to `main`
- Supports manual apply per environment via workflow dispatch
- Enforces formatting and plan review before infrastructure changes

## Remote State Setup

- S3 Bucket: `ec2-oe-terraform-state-prince`
- State paths: `envs/dev/terraform.tfstate`, `envs/prod/terraform.tfstate`
- DynamoDB Table: `terraform-locks`

## SSM Parameters Used

| Environment | Parameter Name               | Description       |
|-------------|-------------------------------|-------------------|
| dev         | /ec2-oe/dev/ami_id            | AMI ID            |
| dev         | /ec2-oe/dev/instance_type     | EC2 instance type |
| prod        | /ec2-oe/prod/ami_id           | AMI ID            |
| prod        | /ec2-oe/prod/instance_type    | EC2 instance type |

## Author

Prince Rajput  
AWS | Terraform | DevOps | Infra as Code

```
