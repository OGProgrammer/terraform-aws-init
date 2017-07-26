#!/usr/bin/env bash
echo "REPOSITORY: terraform-aws-init"
echo "SCRIPT: tf-plan.sh <region>"
echo "EXECUTING: terraform plan"
echo "NOTE: Ensure your default ssh key (~/.ssh/id_rsa.pub) is the one you want to use for the root key."

echo "Checking for aws cli..."
if ! [ -x "$(command -v aws)" ]; then
    echo 'Error: aws cli is not installed.' >&2
    exit 1
fi

target_aws_region=$1
if [ -z "$target_aws_region" ]; then
    echo 'Error: You must provide a target region.' >&2
    echo 'Example Usage: ./tf-plan.sh us-west-2' >&2
    exit 1
fi

# Needed for Terraform AWS Provider {}
export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)

# Get the contents of your ssh key
sshKeyContents=$(cat ~/.ssh/id_rsa.pub)

# Uncomment for verbose terraform output
#export TF_LOG=info

echo "terraform plan -var ssh_key=${sshKeyContents} -var region=${target_aws_region}"
if terraform plan -var "ssh_key=${sshKeyContents}" -var "region=${target_aws_region}" ; then
    echo "Terraform plan succeeded."
else
    echo 'Error: terraform plan failed.' >&2
    exit 1
fi

echo "Ensure you see your public key being added above."

echo "done"