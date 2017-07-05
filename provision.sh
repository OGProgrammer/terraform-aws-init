#!/usr/bin/env bash
echo "Ensure your default ssh key is the one you want to use for the root key."

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

#export TF_LOG=info

echo "Executing terraform plan"
if terraform plan -var "ssh_key=${sshKeyContents}" ; then
    echo "Terraform plan succeeded."
else
    echo 'Error: terraform plan failed.' >&2
    exit 1
fi

echo "Ensure you see your public key being added above."
echo "Do you want to continue? (yes/no)"
read input
if [ "$input" == "yes" ]
then
    echo "Executing terraform apply"
    if terraform apply -var "ssh_key=${sshKeyContents}" ; then
        echo "Terraform apply succeeded."
    else
        echo 'Error: terraform apply failed.' >&2
        exit 1
    fi
fi
