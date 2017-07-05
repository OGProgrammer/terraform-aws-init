# terraform-aws-init

This is your starting point for initializing your AWS infrastructure.

1. Log into the [AWS console](https://aws.amazon.com) and create an IAM user for you to use in your CLI.

2. Create an IAM user with the AdministratorAccess policy attached so you can do all sorts of naughty things.

3. Get programmatic access via the key+secret which you will need in a minute. Download the credentials.csv for safe keeping.

4. Setup [AWS CLI](http://docs.aws.amazon.com/cli/latest/userguide/installing.html) (I just used `brew install awscli`)

5. Run `aws configure` and paste the key+secret you got earlier. Use us-west-2 or whatever region as your default. No default output needed.

6. Install [Terraform](https://www.terraform.io/downloads.html)

7. Run `./provision.sh` to plan the terraform recipe. You should see `Plan: 6 to add, 0 to change, 0 to destroy.` and your ssh key being added.

8. Type `yes` and hit return to continue provisioning base things needed.

9. Once terraform creates these things needed. Keep the `terraform.tfstate` & `terraform.tfstate.backup` file in a safe, centralized place.

10. You're all done! Congrats on nailing your first step.

On another note, to destroy these resources. Simple run the `destroy.sh` script to run a `terraform destroy`

