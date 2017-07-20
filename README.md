# terraform-aws-init

This is your starting point for initializing your AWS infrastructure.

I recommend cloning all the repos needed for this example by running the following:

```
bash <(curl -s https://raw.githubusercontent.com/OGProgrammer/terraform-aws-init/master/clone-cd-example.sh)
```

---

## Instructions

1. Log into the [AWS console](https://aws.amazon.com) and create an IAM user for you to use in your CLI.

2. Create an IAM user with the AdministratorAccess policy attached so you can do all sorts of naughty things.

3. Get programmatic access via the key+secret which you will need in a minute. Download the credentials.csv for safe keeping.

4. Setup [AWS CLI](http://docs.aws.amazon.com/cli/latest/userguide/installing.html) (I just used `brew install awscli`)

5. Run `aws configure` and paste the key+secret you got earlier. Use us-west-2 or whatever region as your default. No default output needed.

6. Install [Terraform](https://www.terraform.io/downloads.html)

7. Run `./tf-plan.sh` to test the terraform recipe. You should see `Plan: 6 to add, 0 to change, 0 to destroy.` and your ssh key being added.

8. Run `./tf-apply.sh` to deploy the base AWS resources you'll need for the rest of your infrastructure and services.

9. Once terraform creates these things needed. Keep the `terraform.tfstate` & `terraform.tfstate.backup` file in a safe place. This will be the only state file not stored in S3 since this is your base resources needed to store other terraform state files.

10. You're all done! Congrats on nailing your first step to creating your infrastructure.

---
 
On another note, to destroy these resources. Simply run the `./tf-destroy.sh` script to destroy what you've made.

You may receive an error saying BucketNotEmpty when destroying this but please be sure you destroyed ALL other terraform infrastructure and services before you do because your literally killing off what holds all your terraform state files. 

Carefully run the following command to empty the bucket out, then rerun the destroy script. Replace the region name if you changed it.

```
aws s3 rm s3://terraform-states-logs-us-west-2 --recursive
```