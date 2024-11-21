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
curl -u "64eyes" https://api.github.com/user/repos -d '{"name": "'"$repoName"'", "private":false}'

# Get the clone URL for the newly created repository
GIT_URL=$(curl -u "64eyes" -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/64eyes/"$repoName" | jq -r '.clone_url')

# Configure Git
git branch -M main
git remote add origin "$GIT_URL"

# Optionally push to GitHub
git push -u origin main
