#!/usr/bin/env bash

# downloads all repos and creates a gource viz of all of them together

set -e
set -u
set -o pipefail

# Create a directory for the repositories
mkdir -p ./repos
cd ./repos

# Read the repos.txt file into an array
mapfile -t lines < ../repos.txt

# Get the total number of repos
total=${#lines[@]}

# Define a function for the tasks to be done
clone_or_pull() {
  repo=$1
  logfile=$repo.log
  if [[ -d $repo ]]; then
    # If repo already exists, force update it
    echo "Updating ${repo}..."
    cd $repo
    git pull --force >$logfile 2>&1
    cd ..
  else
    # Otherwise, clone the repo
    echo "Cloning ${repo}..."
    git clone git@github.com:MetaMask/${repo}.git >$logfile 2>&1
  fi
  
  # Check git exit status and print log if it failed
  if [ $? -ne 0 ]; then
    cat $logfile
  fi

  # Remove the log file
  rm "$repo/$logfile"
}
export -f clone_or_pull

# Execute the function for each repo in parallel
printf "%s\n" "${lines[@]}" | xargs -n 1 -P 0 -I {} bash -c 'clone_or_pull "$@"' _ {}

cd ..
