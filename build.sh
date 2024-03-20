#!/bin/bash
# ./build.sh v1.0.0 "this is the github commit code"

# Update Docker Image Version in ansible/playbook.yml
echo "Updating Docker version in playbook.yml to $1"
OLD_VERSION=$(grep -Po '(?<=v0\.0\.)\d+' ansible/playbook.yml | tail -n 1)
sed -i "s/v0\.0\.$OLD_VERSION/$1/g" ansible/playbook.yml

# Commit changes to GitHub
echo "Committing changes to GitHub with commit message: $2"
git add .
git commit -m "$2"
git tag -a $1 HEAD -m "$2"
git push

# Create GitHub release
echo "Creating GitHub release"
GH_TOKEN=$(cat ~/Downloads/github-token.txt)
GH_REPO="rhysctf/devops-aws"
GH_API="https://api.github.com/repos/$GH_REPO"
TAG_NAME="$1"
curl -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: token $GH_TOKEN" \
    -d "{\"tag_name\": \"$TAG_NAME\"}" \
    "$GH_API/releases"

# Build new Docker Image
echo "Building new Docker Image with Image Tag: $1"
docker build -t rhys7homas/devops-aws:$1 -f ansible/Dockerfile .
docker push rhys7homas/devops-aws:$1

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

# Clean up Terraform resources
# echo "Destroying Terraform resources"
# terraform -chdir=terraform destroy -auto-approve

echo "Done"