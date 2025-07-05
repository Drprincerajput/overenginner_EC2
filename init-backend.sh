#!/bin/bash

set -e

ENV=$1

if [[ -z "$ENV" ]]; then
  echo "Usage: ./init-backend.sh <dev|prod>"
  exit 1
fi

cd envs/$ENV

echo "Selecting or creating Terraform workspace: $ENV"
terraform workspace select $ENV || terraform workspace new $ENV

echo "Reinitializing backend for $ENV"
terraform init \
  -reconfigure \
  -backend-config="${ENV}.backend.tfvars"

echo "Backend initialized and reconfigured for $ENV"
