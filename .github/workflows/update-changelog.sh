#!/bin/bash

# Convert GitHub date format to YYYY-MM-DD
FORMATTED_DATE=$(date -d "$RELEASE_DATE" '+%Y-%m-%d')

# Initialize sections
ADDED=""
CHANGED=""
FIXED=""
REMOVED=""
SECURITY=""

process_commit_line() {
  local line=$1

  # Remove leading "* "
  line=${line#\* }

  if echo "$line" | grep -qE '^([a-z]+)([^:]*):(.+)$'; then
    local type=$(echo "$line" | grep -oE '^[a-z]+')
    local scope=$(echo "$line" | grep -oE '^[a-z]+([^:]*)')
    scope=${scope#$type}
    local message=$(echo "$line" | grep -oE ':(.+)$')
    message=${message#:}

    # Trim whitespace
    message="${message#"${message%%[![:space:]]*}"}"

    # Remove everything after "by @"
    message=$(echo "$message" | sed 's/ by @.*$//')

    # Add scope if present
    if [ ! -z "$scope" ]; then
      echo "- ${message} ${scope}"
    else
      echo "- ${message}"
    fi
  fi
}

while IFS= read -r line; do
  if [[ $line =~ ^"* "* ]]; then
    processed_line=$(process_commit_line "$line")

    # Categorize based on commit type
    if [[ $line =~ ^"* feat"* ]]; then
      ADDED+="$processed_line\n"
    elif [[ $line =~ ^"* fix"* ]]; then
      FIXED+="$processed_line\n"
    elif [[ $line =~ ^"* refactor"* ]]; then
      CHANGED+="$processed_line\n"
    elif [[ $line =~ ^"* security"* ]]; then
      SECURITY+="$processed_line\n"
    elif [[ $line =~ ^"* breaking"* ]]; then
      REMOVED+="$processed_line\n"
    fi
  fi
done <<< "$RELEASE_BODY"

# Create changelog entry
CHANGELOG_ENTRY="## [$RELEASE_TAG] - $FORMATTED_DATE\n"

# Add non-empty sections
[[ ! -z "$ADDED" ]] && CHANGELOG_ENTRY+="\n### Added\n$ADDED"
[[ ! -z "$CHANGED" ]] && CHANGELOG_ENTRY+="\n### Changed\n$CHANGED"
[[ ! -z "$FIXED" ]] && CHANGELOG_ENTRY+="\n### Fixed\n$FIXED"
[[ ! -z "$REMOVED" ]] && CHANGELOG_ENTRY+="\n### Removed\n$REMOVED"
[[ ! -z "$SECURITY" ]] && CHANGELOG_ENTRY+="\n### Security\n$SECURITY"

# Update CHANGELOG.md
if [ -f CHANGELOG.md ]; then
  sed -i "1a\\$CHANGELOG_ENTRY" CHANGELOG.md
else
  echo "# Changelog\n\n$CHANGELOG_ENTRY" > CHANGELOG.md
fi