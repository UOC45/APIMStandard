#!/bin/bash

set -e

# validate if wants to proceed

source "./.env"

tfvars_file="../../apim-baseline/terraform/${ENVIRONMENT_TAG}.tfvars"

if [[ ! -f "$tfvars_file" ]]; then
  echo "Error: tfvars file not found at $tfvars_file"
  echo "Please ensure the deployment was completed successfully before destroying."
  exit 1
fi

echo "Using TFVARS: $tfvars_file"

echo "Do you want to destroy the deployment? (y/n)"
read -r response

if [[ $response =~ ^[Yy]$ ]]; then

    cd ../../apim-baseline/terraform 
    terraform destroy --auto-approve -var-file="${ENVIRONMENT_TAG}.tfvars"
else
	echo "Exiting..."
fi