# terraform-aws-init

This is your starting point for initializing your AWS infrastructure.

I recommend cloning all the repos needed for this example by running the following:

```
bash <(curl -s https://raw.githubusercontent.com/OGProgrammer/terraform-aws-init/master/clone-examples.sh)

```

---

## Requirements

* Terraform 0.9+

## Instructions

1. Log into the [AWS console](https://aws.amazon.com) and create an IAM user for you to use in your CLI.

2. Create an IAM user with the AdministratorAccess policy attached so you can do all sorts of naughty things.

3. Get programmatic access via the key+secret which you will need in a minute. Download the credentials.csv for safe keeping.

4. Setup [AWS CLI](http://docs.aws.amazon.com/cli/latest/userguide/installing.html) (I just used `brew install awscli`)

5. Run `aws configure` and paste the key+secret you got earlier. No default region or output format needed.

6. Install [Terraform](https://www.terraform.io/downloads.html)

7. Run `./tf-plan.sh us-west-2` to test it. You should see `Plan: 6 to add, 0 to change, 0 to destroy.` and your ssh key being added.

8. Run `./tf-apply.sh us-west-2` to deploy the base AWS resources you'll need for the rest of your infrastructure and services.

9. Once terraform creates these things needed. Keep the `terraform.tfstate` & `terraform.tfstate.backup` file in a safe place. This will be the only state file not stored in S3 since this is your base resources needed to store other terraform state files.

10. You're all done! Congrats on nailing your first step to creating your infrastructure.

---

### Destroying 
To destroy these resources, simply run the `./tf-destroy.sh us-west-2` script to destroy *EVERYTHING*. This includes your s3 buckets, state files, logs, etc.

### Launching in more than one region

If you plan on doing more than one region, clone this repo with the region suffixed. Ex. "terraform-aws-init-us-west-2"

Otherwise, your existing tfstate file will clash with the first region you provisioned.
