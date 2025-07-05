#!/bin/bash

set -e

echo "Bootstrapping SSM parameters..."

aws ssm put-parameter \
  --name "/ec2-oe/dev/ami_id" \
  --type "String" \
  --value "ami-05ffe3c48a9991133" \
  --overwrite \
  --region us-east-1

aws ssm put-parameter \
  --name "/ec2-oe/dev/instance_type" \
  --type "String" \
  --value "t2.micro" \
  --overwrite \
  --region us-east-1

aws ssm put-parameter \
  --name "/ec2-oe/prod/ami_id" \
  --type "String" \
  --value "ami-05ffe3c48a9991133" \
  --overwrite \
  --region us-east-1

aws ssm put-parameter \
  --name "/ec2-oe/prod/instance_type" \
  --type "String" \
  --value "t2.small" \
  --overwrite \
  --region us-east-1

echo "SSM parameters created."
