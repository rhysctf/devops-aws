#!/bin/bash
# ./build.sh v1.0.0 "this is the github commit code"

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