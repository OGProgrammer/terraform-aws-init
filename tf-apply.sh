#!/usr/bin/env bash
echo "REPOSITORY: terraform-aws-init"
echo "SCRIPT: tf-apply.sh <s3_prefix> <region> <public_key>"
echo "EXECUTING: terraform apply"

echo "Checking for aws cli..."
if ! [ -x "$(command -v aws)" ]; then
    echo 'Error: aws cli is not installed.' >&2
    exit 1
fi

s3_prefix=$1
if [ -z "$s3_prefix" ]; then
    echo "An s3 prefix must be provided! Failing out."
    exit 1
fi

# Set target aws region
target_aws_region=$2
if [ -z "$target_aws_region" ]; then
    target_aws_region=us-west-2
    echo "No region was passed in, using \"${target_aws_region}\" as the default"
fi

# Set public key
public_key=$3
if [ -z "$public_key" ]; then
    public_key=~/.ssh/id_rsa.pub
    echo "No public key was passed in, using \"${public_key}\" as the default"
fi
# Check the key exists
if [ ! -f ${public_key} ]; then
    echo "Error: public key \"${public_key}\" does not exist!" >&2
    exit 1
fi

# Get the contents of your ssh key
ssh_key=$(cat ${public_key})

#Download plugins
terraform init

# Needed for Terraform AWS Provider {}
export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)

# Uncomment for verbose terraform output
#export TF_LOG=info

echo "terraform apply -var \"s3prefix=${s3_prefix}\" -var \"ssh_key=${ssh_key}\" -var \"region=${target_aws_region}\""
if terraform apply -var "s3prefix=${s3_prefix}" -var "ssh_key=${ssh_key}" -var "region=${target_aws_region}" ; then
    echo "Terraform apply succeeded."
else
    echo 'Error: terraform apply failed.' >&2
    exit 1
fi

echo "Apply Completed";