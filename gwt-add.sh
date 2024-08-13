#!/usr/bin/env bash
set -euo pipefail

# Enhanced usage message to include all use cases
usage() {
    >&2 echo "Usage:"
    >&2 echo "  gwt-branch-add <repo_dir> <branch_name> [base_branch_or_commit_sha]"
    >&2 echo ""
    >&2 echo "Examples:"
    >&2 echo "  1. Create a new branch 'new-feature' from the latest commit of the default branch:"
    >&2 echo "     gwt-branch-add repo.worktrees new-feature"
    >&2 echo ""
    >&2 echo "  2. Create a new branch 'new-feature' from another existing branch 'development':"
    >&2 echo "     gwt-branch-add repo.worktrees new-feature development"
    >&2 echo ""
    >&2 echo "  3. Create a new branch 'bugfix' from a specific historical commit 'abc1234':"
    >&2 echo "     gwt-branch-add repo.worktrees bugfix abc1234"
    >&2 echo ""
    >&2 echo "Arguments:"
    >&2 echo "  <repo_dir>  - Directory where the repository was cloned using 'gwt-clone'"
    >&2 echo "  <branch_name> - Name of the new branch to create and add as a worktree"
    >&2 echo "  [base_branch_or_commit_sha] - (Optional) Base branch or commit SHA to create the new branch from."
    >&2 echo "                                 If not specified, the branch will be created from the latest commit of the default branch."
    >&2 echo ""
    exit 1
}

if [ $# -lt 2 ]; then
    usage
fi

# Arguments
REPO_DIR=$1
BRANCH_NAME=$2
BASE_REF=${3:-}  # Optional, can be either a branch name or a commit SHA

# Directory variables
BARE_REPO_DIR="$REPO_DIR/.bare"
WORKTREE_DIR="$REPO_DIR/$BRANCH_NAME"

# Ensure the .bare directory exists
if [ ! -d "$BARE_REPO_DIR" ]; then
    >&2 echo "Error: .bare directory does not exist in $REPO_DIR"
    exit 1
fi

# Function to check if a branch or commit exists
branch_or_commit_exists() {
    git --git-dir="$BARE_REPO_DIR" rev-parse --verify --quiet "$1" > /dev/null
}

# If a base reference is provided
if [ -n "$BASE_REF" ]; then
    if branch_or_commit_exists "$BASE_REF"; then
        echo "Creating branch '$BRANCH_NAME' from '$BASE_REF'..."
        git --git-dir="$BARE_REPO_DIR" branch "$BRANCH_NAME" "$BASE_REF"
    else
        >&2 echo "Error: Base branch or commit '$BASE_REF' does not exist."
        exit 1
    fi
else
    # Create a new branch from the latest commit of the main branch
    echo "Creating branch '$BRANCH_NAME' from the latest commit of the default branch..."
    DEFAULT_BRANCH=$(git --git-dir="$BARE_REPO_DIR" symbolic-ref --short HEAD)
    git --git-dir="$BARE_REPO_DIR" branch "$BRANCH_NAME" "$DEFAULT_BRANCH"
fi

# Create and add the worktree for the specified branch
echo "Adding worktree for branch '$BRANCH_NAME'..."
git --git-dir="$BARE_REPO_DIR" worktree add "$WORKTREE_DIR" "$BRANCH_NAME"

echo "Worktree for branch '$BRANCH_NAME' added at '$WORKTREE_DIR'"
