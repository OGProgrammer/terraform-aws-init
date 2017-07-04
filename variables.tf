variable "ssh_key" {
  description = "The root ssh key used to access AWS resources."
}

variable "region" {
  default = "us-west-2"
  description = "The main AWS region."
}