#!/usr/bin/env bash
echo "REPOSITORY: terraform-aws-init"
echo "SCRIPT: tf-destroy.sh <region> <public_key>"
echo "EXECUTING: terraform destroy"

echo "Checking for aws cli..."
if ! [ -x "$(command -v aws)" ]; then
    echo 'Error: aws cli is not installed.' >&2
    exit 1
fi

#Download plugins
terraform init

# Set target aws region
target_aws_region=$1
if [ -z "$target_aws_region" ]; then
    target_aws_region=us-west-2
    echo "No region was passed in, using \"${target_aws_region}\" as the default"
fi

# Set public key
public_key=$2
if [ -z "$public_key" ]; then
    public_key=~/.ssh/id_rsa.pub
    echo "No public key was passed in, using \"${public_key}\" as the default"
fi
# Check the key exists
if [ ! -f ${public_key} ]; then
    echo "Error: public key \"${public_key}\" does not exist!" >&2
    exit 1
fi

# Needed for Terraform AWS Provider {}
export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)

# Clean out s3 buckets before calling terraform destroy to avoid error that buckets are not empty
echo "Deleting everything in terraform/jenkins s3 buckets!"
./empty-s3-bucket.sh terraform-states-${target_aws_region}
aws s3 rm s3://terraform-states-logs-${target_aws_region} --recursive
aws s3 rm s3://terraform-states-${target_aws_region} --recursive
aws s3 rm s3://jenkins-files-${target_aws_region} --recursive

# Get the contents of your ssh key
sshKeyContents=$(cat ${public_key})

# Export Terraform Variables
export TF_VAR_region="${target_aws_region}"
export TF_VAR_ssh_key="${sshKeyContents}"

# Uncomment for verbose terraform output
#export TF_LOG=info

echo "terraform destroy -force"
if terraform destroy -force ; then
    echo "Terraform destroy succeeded."
else
    echo 'Error: terraform destroy failed.' >&2
    exit 1
fi

echo "done"