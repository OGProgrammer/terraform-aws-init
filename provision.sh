export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
export AWS_DEFAULT_REGION="us-west-2"
terraform plan -var "ssh_key=$(cat ~/.ssh/id_rsa.pub)"
