#!/usr/bin/env bash
set -euo pipefail

# Directory where the bare repo and worktrees are located
REPO_DIR=$1

# get full REPO_DIR path
REPO_DIR=$(realpath "$REPO_DIR")

if [ ! -d "$REPO_DIR/.bare" ]; then
    >&2 echo "Error: .bare directory does not exist in $REPO_DIR"
    exit 1
fi

# List all worktrees and pull updates
git --git-dir="$REPO_DIR/.bare" worktree list --porcelain | awk '/^worktree/ {print $2}' | while read -r WORKTREE_PATH; do
    
    if [ -d "$WORKTREE_PATH" ]; then

         # ignore the bare repo itself
        if [ "$WORKTREE_PATH" = "$REPO_DIR/.bare" ]; then
            continue
        fi

        echo "Pulling updates in $WORKTREE_PATH..."
        git --git-dir="$WORKTREE_PATH/.git" --work-tree="$WORKTREE_PATH" pull
    else
        echo "Skipping non-existent worktree at $WORKTREE_PATH"
    fi
done
