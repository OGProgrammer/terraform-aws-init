#!/usr/bin/env bash
echo "REPOSITORY: terraform-aws-init"
echo "SCRIPT: tf-destroy.sh <region>"
echo "EXECUTING: terraform destroy"

echo "Checking for aws cli..."
if ! [ -x "$(command -v aws)" ]; then
    echo 'Error: aws cli is not installed.' >&2
    exit 1
fi

target_aws_region=$1
if [ -z "$target_aws_region" ]; then
    echo 'Error: You must provide a target region.' >&2
    echo 'Example Usage: ./tf-destroy.sh us-west-2' >&2
    exit 1
fi

# Needed for Terraform AWS Provider {}
export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)

# Get the contents of your ssh key
sshKeyContents=$(cat ~/.ssh/id_rsa.pub)

# Uncomment for verbose terraform output
#export TF_LOG=info

echo "terraform destroy -force -var ssh_key=${sshKeyContents} -var region=${target_aws_region}"
if terraform destroy -force -var "ssh_key=${sshKeyContents}" -var "region=${target_aws_region}" ; then
    echo "Terraform destroy succeeded."
else
    echo 'Error: terraform destroy failed.' >&2
    exit 1
fi

echo "done"