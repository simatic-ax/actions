#!/bin/bash
set -e  # Exit on error
set -x  # Enable debug output

# Ensure jq is available
if ! command -v jq &> /dev/null; then
    echo "jq is not installed. Installing..."
    apt-get update && apt-get install -y jq
fi

# Check if required environment variables are set
if [ -z "$GITHUB_TOKEN" ] || [ -z "$RELEASE_BODY" ] || [ -z "$RELEASE_TAG" ] || [ -z "$RELEASE_DATE" ] || [ -z "$GITHUB_REPOSITORY" ] || [ -z "$TARGET_BRANCH" ]; then
    echo "Error: Required environment variables are not set"
    echo "GITHUB_TOKEN: ${GITHUB_TOKEN:+set}"
    echo "RELEASE_BODY: ${RELEASE_BODY:+set}"
    echo "RELEASE_TAG: ${RELEASE_TAG:+set}"
    echo "RELEASE_DATE: ${RELEASE_DATE:+set}"
    echo "GITHUB_REPOSITORY: ${GITHUB_REPOSITORY:+set}"
    echo "TARGET_BRANCH: ${TARGET_BRANCH:+set}"
    exit 1
fi

# Debug workspace
echo "Current directory:"
pwd
ls -la

# Git configuration
git config --global --add safe.directory "$GITHUB_WORKSPACE"
git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"

# Create and switch to changelog branch
BRANCH_NAME="changelog-update-$RELEASE_TAG"
echo "Creating branch: $BRANCH_NAME"
git checkout -b "$BRANCH_NAME"

# Debug update-changelog.sh
echo "Checking update-changelog.sh:"
ls -la .github/workflows/update-changelog.sh
echo "Content of update-changelog.sh:"
cat .github/workflows/update-changelog.sh

# Update changelog
echo "Making update-changelog.sh executable"
chmod +x .github/workflows/update-changelog.sh
echo "Executing update-changelog.sh"
.github/workflows/update-changelog.sh

# Debug changes
echo "Git status after changelog update:"
git status

# Stage only CHANGELOG.md
echo "Staging CHANGELOG.md"
git add CHANGELOG.md
echo "Git status after staging:"
git status --short

# Commit and push changes
echo "Committing changes"
git commit -m "docs: update changelog for $RELEASE_TAG"
echo "Pushing branch"
git push origin "$BRANCH_NAME"

# Create PR and store response
echo "Creating PR"
PR_RESPONSE=$(curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/$GITHUB_REPOSITORY/pulls" \
  -d "{
    \"title\": \"docs: update changelog for $RELEASE_TAG\",
    \"body\": \"Automated changelog update for release $RELEASE_TAG\",
    \"head\": \"$BRANCH_NAME\",
    \"base\": \"$TARGET_BRANCH\"
  }")

echo "PR creation response:"
echo "$PR_RESPONSE"

PR_NUMBER=$(echo "$PR_RESPONSE" | jq -r '.number')
echo "PR number: $PR_NUMBER"

# Submit review
echo "Submitting review"
REVIEW_RESPONSE=$(curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/$GITHUB_REPOSITORY/pulls/$PR_NUMBER/reviews" \
  -d '{
    "event": "APPROVE",
    "body": "Automated approval for changelog update"
  }')

echo "Review response:"
echo "$REVIEW_RESPONSE"

# Merge PR
echo "Merging PR"
MERGE_RESPONSE=$(curl -L \
  -X PUT \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/$GITHUB_REPOSITORY/pulls/$PR_NUMBER/merge" \
  -d '{
    "merge_method": "merge"
  }')

echo "Merge response:"
echo "$MERGE_RESPONSE"

# Clean up branch
echo "Deleting branch"
git push origin --delete "$BRANCH_NAME"

echo "Script completed"