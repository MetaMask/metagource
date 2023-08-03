#!/usr/bin/env bash

set -e
set -u
set -o pipefail

# GitHub organization name
org_name="metamask"

# Ignore list
ignore_list=(
  # talk slides that reuse a template
  "devcon1-talk"
  "talk-devcon2"
  "talk-devcon3"
  "repos/talk-devcon4"
  "talk-hongkong-2016"
  # old website, based on a template
  "old-landing"
  # metamask-extension fork
  "metamask-snaps-beta"
  "metamask-desktop"
  "metamask-filecoin-developer-beta"
)

# Initial GitHub API URL
url="https://api.github.com/orgs/${org_name}/repos?type=sources&per_page=100&page=1"

# Array to hold repositories
declare -a repo_list

# While the URL is not empty
while [[ -n $url ]]; do
  # Fetch the repositories from the URL, and get the Link header
  response=$(curl -s -I -H "Accept: application/vnd.github.v3+json" "$url")

  # Get the repos
  repos=$(curl -s -H "Accept: application/vnd.github.v3+json" "$url" | jq -r '.[].name')

  # Check each repo against the ignore list and add to repo_list if not in ignore_list
  for repo in $repos; do
      if [[ ! " ${ignore_list[@]} " =~ " ${repo} " ]]; then
          repo_list+=("$repo")
      fi
  done

  # Get the next URL from the Link header
  url=$(echo "$response" | grep -oP '(?<=<)[^>]+(?=>; rel="next")')
done

# Now you have all repositories (excluding the ignored ones) in the repo_list array
# You can print it or use it as needed
for repo in "${repo_list[@]}"; do
  echo "$repo"
done > repos.txt