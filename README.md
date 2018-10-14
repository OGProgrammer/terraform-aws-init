# terraform-aws-init

This is your starting point for initializing your AWS infrastructure.

I recommend cloning all the repos needed for this example by running the following:

```
bash <(curl -s https://raw.githubusercontent.com/OGProgrammer/terraform-aws-init/master/clone-examples.sh)

```

This is apart of a Terraform+Jenkins+AWS+Docker Tutorial I give at conferences and private corporate events. This is a dev ops dream come true.

Tutorial prep notes can be found on this [gist](https://gist.github.com/OGProgrammer/d07692840e01d5bab9d288f49daacc36)

Slides can be found [here](https://docs.google.com/presentation/d/1KeZn1z-p2zWoeeI8hxI-B7DI1wkBDjSjXU5_k1OsjJM/edit?usp=sharing)

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

7. Think of a unique string for an s3 prefix. Ex. "zcoe18". You'll be using this throughout the tutorial.

8. Drop into a terminal and run the terraform plan script. `./tf-plan.sh <s3prefix> <region>` Replace the s3 prefix with your unique string and provide a region or leave blank for us-west-2. Something like:

`./tf-plan.sh optimus-prime-87 us-west-2`

You should see `Plan: 4 to add, 0 to change, 0 to destroy.` and your ssh key being added.

9. Run `./tf-apply.sh <s3prefix> <region>` to deploy the base AWS resources you'll need for the rest of your infrastructure and services (like Jenkins).

10. Once terraform creates these things needed. Keep the `terraform.tfstate` & `terraform.tfstate.backup` file in a safe place. This will be the only state file not stored in S3 since this is your base resources needed to store other terraform state files.

11. You're all done! Congrats on nailing your first step to lay the foundation for your infrastructure with s3 buckets to store important config files. 

Head over to the `terraform-aws-jenkins` repo [here](https://github.com/OGProgrammer/terraform-aws-jenkins) for the next step of this tutorial.

---

### Destroying 

To destroy these resources, simply run the `./tf-destroy.sh <s3prefix> <region>` script with your s3 prefix and target region (or empty for us-west-2) to destroy *EVERYTHING*. This includes your s3 buckets, state files, logs, etc. Only do this if you've already destroyed the `terraform-aws-jenkins` repo from your AWS account and any other services you've wired up to this.

### Launching in more than one region

If you plan on doing more than one region, clone this repo with the region suffixed. Ex. "terraform-aws-init-us-west-2"

Otherwise, your existing tfstate file will clash with the first region you provisioned.

Alternatively, you could start hard coding regions into your terraform recipe to hand craft your root s3 buckets.

```
Built & Maintained by @OGProgrammer

Support Your Local User Groups
http://php.ug/

Check out our PHP UG in Las Vegas, NV
http://PHPVegas.com

Support your local tech scene!
#VegasTech

Share your knowledge!
Become a speaker, co-organizer, at your local user groups.
Contribute to your favorite open source packages (even if its a README ;)

Thank you! ☺

-Josh

Paid support and training services available at http://RemoteDevForce.com
```