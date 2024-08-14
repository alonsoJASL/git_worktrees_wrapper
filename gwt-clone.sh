#!/usr/bin/env bash
set -euo pipefail

if [ $# -eq 0 ] ; then
    >&2 echo 'No arguments supplied'
    >&2 echo 'Usage: gwt-clone <repo_url> [main_branch]'
    exit 1
fi

# Variables
REPO_URL=$1 
REPO_NAME=$(basename $REPO_URL .git)

BASE_DIR="$REPO_NAME.worktrees"
MAIN_BRANCH=${2:-main} # Default to main

echo "REPO_URL: $REPO_URL in $BASE_DIR, MAIN_BRANCH: $MAIN_BRANCH"

# Step 1: Clone the repository as a bare repo
git clone --bare $REPO_URL $BASE_DIR/.bare

# Step 2: Create and add the main worktree
mkdir -p $BASE_DIR/$MAIN_BRANCH

cd $BASE_DIR
git --git-dir=.bare worktree add $MAIN_BRANCH $MAIN_BRANCH