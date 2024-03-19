provider "aws" {
  region     = var.region
}

resource "aws_instance" "test" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = ["devops-security-group"]  # Use an existing security group by name

  tags = {
    Name = "Test Instance"
  }
}