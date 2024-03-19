#!/bin/bash

# Initialize Terraform
echo "Initializing Terraform"
terraform -chdir=terraform init

# Provision infrastructure using Terraform
echo "Provisioning infrastructure using Terraform"
terraform -chdir=terraform apply -auto-approve

# Extract public IP of the EC2 instance
echo "Extracting public IP of the EC2 instance"
EC2_PUBLIC_IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=Test Instance" --query "Reservations[].Instances[].PublicIpAddress" --output text)

# Wait for SSH to be available
echo "Waiting for SSH to be available"
while ! ssh -o StrictHostKeyChecking=no -i ~/Downloads/devops-key-pair.pem ubuntu@"$EC2_PUBLIC_IP" true; do
    echo "SSH is not available yet. Waiting..."
    sleep 5
done

# Run Ansible playbook to configure the EC2 instance
echo "Running Ansible playbook to configure the EC2 instance"
ansible-playbook -i "$EC2_PUBLIC_IP," -u ubuntu --private-key=~/Downloads/devops-key-pair.pem ansible/playbook.yml

echo "Done"