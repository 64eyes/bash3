#!/bin/bash

repoName=$1

# Prompt for a repository name if not provided
while [ -z "$repoName" ]; do
  echo "Provide a repository name"
  read -r -p "Repository name: " repoName
done

# Create a README file with the repo name as a header
echo "# $repoName" >> README.md

# Initialize Git and commit
git init
git add .
git commit -m "First commit"

# Create a new GitHub repository using the API
create_response=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
                          -H "Accept: application/vnd.github.v3+json" \
                          https://api.github.com/user/repos \
                          -d '{"name": "'"$repoName"'", "private":false}')


# Check if the repository was created successfully
if echo "$create_response" | grep -q '"clone_url"'; then
  GIT_URL=$(echo "$create_response" | jq -r '.clone_url')
else
  echo "Failed to create GitHub repository. Response: $create_response"
  exit 1
fi

# Configure Git
git branch -M main
git remote add origin "$GIT_URL"

# Push changes to the new repository
git push -u origin main
