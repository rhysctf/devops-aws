variable "region" {
  description = "The AWS region where resources will be created."
  default        = "eu-west-2"
}

variable "ami_id" {
  description = "The ID of the AMI to use for the EC2 instance."
  default        = "ami-0b9932f4918a00c4f"
}

variable "instance_type" {
  description = "The type of EC2 instance."
  default        = "t2.micro"
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access."
  default        = "devops-key-pair"
}