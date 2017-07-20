#!/usr/bin/env bash
echo "REPOSITORY: terraform-aws-init"
echo "EXECUTING: terraform destroy"

echo "Checking for aws cli..."
if ! [ -x "$(command -v aws)" ]; then
    echo 'Error: aws cli is not installed.' >&2
    exit 1
fi

# Needed for Terraform AWS Provider {}
export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
export AWS_DEFAULT_REGION=$(aws configure get region)

# Get the contents of your ssh key
sshKeyContents=$(cat ~/.ssh/id_rsa.pub)

# Uncomment for verbose terraform output
#export TF_LOG=info

echo "Executing terraform destroy. Astalavista... Baby."
echo "terraform destroy -force -var ssh_key=${sshKeyContents}"

if terraform destroy -force -var "ssh_key=${sshKeyContents}" ; then
    echo "Terraform destroy succeeded."
else
    echo 'Error: terraform destroy failed.' >&2
    exit 1
fi

echo "done"