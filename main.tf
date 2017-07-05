# A shared IAM role for jenkins which has two policy documents attached. IAM stuff & Power User Access.
resource "aws_iam_role" "jenkins" {
  name = "jenkins"
  path = "/"
  assume_role_policy = "${file("JenkinsIAM.json")}"
}

# @todo It's is on you to restrict this jenkins role to your security requirements.
resource "aws_iam_role_policy_attachment" "poweruser-attach" {
  role       = "${aws_iam_role.jenkins.name}"
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

# This is the root ssh key pair on your machine we will be using to access our cloud provisioned resources.
resource "aws_key_pair" "root" {
  key_name   = "root-ssh-key"
  public_key = "${var.ssh_key}"
}

# A bucket for the s3 logs related to the actual terraform states bucket
resource "aws_s3_bucket" "terraform-logs" {
  bucket = "terraform-states-logs-${var.region}"
  acl    = "log-delivery-write"

  tags {
    Name = "terraform-states-logs-${var.region}"
    ManagedBy = "Terraform"
  }
}

# The main terraform states backet
resource "aws_s3_bucket" "terraform-states" {
  bucket = "terraform-states-${var.region}"
  acl    = "private"

  # This is good for just incase the file gets corrupted or something bad.
  versioning {
    enabled = true
  }

  # Send all S3 logs to another bucket
  logging {
    target_bucket = "${aws_s3_bucket.terraform-logs.id}"
    target_prefix = "logs/"
  }

  tags {
    Name = "terraform-states-${var.region}"
    ManagedBy = "Terraform"
  }
}
