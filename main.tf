# Needed to assume an instance role
data "aws_iam_policy_document" "jenkins-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# A shared IAM role for jenkins which has two policy documents attached. IAM stuff & Power User Access.
resource "aws_iam_role" "jenkins" {
  name = "jenkins"
  path = "/"
  assume_role_policy = "${data.aws_iam_policy_document.jenkins-assume-role-policy.json}"
}

# Lets just give power user access to avoid permission issues.
# This is something to revisit going into production on what IAM perms you actually need.
# @todo It's is on you to restrict this jenkins role to your security requirements.
resource "aws_iam_role_policy_attachment" "poweruser-attach" {
  role = "${aws_iam_role.jenkins.name}"
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

# Needed to provision resources in AWS from the Jenkins instance
data "aws_iam_policy_document" "jenkins-iam-control-policy" {
  statement {
    effect = "Allow"
    actions = [
      "iam:AttachRolePolicy",
      "iam:CreatePolicy",
      "iam:CreateRole",
      "iam:DeletePolicy",
      "iam:DeleteRole",
      "iam:DetachRolePolicy",
      "iam:PassRole",
      "iam:GetRole",
      "iam:GetGroup",
      "iam:GetPolicy",
      "iam:GetRolePolicy",
      "iam:GetInstanceProfile",
      "iam:ListAttachedRolePolicies",
      "iam:ListEntitiesForPolicy",
      "iam:ListRolePolicies",
      "iam:ListRoles",
      "iam:PutRolePolicy"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "ec2-read-only-policy-attachment" {
  role = "${aws_iam_role.jenkins.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

# This is the root ssh key pair on your machine we will be using to access our cloud provisioned resources.
resource "aws_key_pair" "root" {
  key_name = "root-ssh-key"
  public_key = "${var.ssh_key}"
}

# A bucket for the s3 logs related to the actual terraform states bucket
resource "aws_s3_bucket" "terraform-logs" {
  bucket = "terraform-states-logs-${var.region}"
  acl = "log-delivery-write"

  tags {
    Name = "terraform-states-logs-${var.region}"
    ManagedBy = "Terraform"
  }
}

# The main terraform states backet
resource "aws_s3_bucket" "terraform-states" {
  bucket = "terraform-states-${var.region}"
  acl = "private"

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
