# GIT Worktrees Wrapper
This project aims to simplify the process of setting up a worktree environment for a given repository.

- `gwt-clone.sh`: Clones a Git repository as a bare repository and sets up a worktree for the main branch.
- `gwt-add.sh`: Adds additional branches to the existing worktree setup, with the option to add branches from historical commits.

## Installation

It is easier to link these scripts to your `/usr/local/bin` folder for easy access:

```shell
sudo ln -s /path/to/gwt/gwt-clone.sh /usr/local/bin/gwt-clone
sudo ln -s /path/to/gwt/gwt-add.sh /usr/local/bin/gwt-add
```

## Usage
### gwt-clone

```shell
gwt-clone <repo_url> [main_branch]
```
+ `<repo_url>`: The URL of the Git repository to clone.
+ `[main_branch]` (optional): The main branch to use for the worktree. Defaults to `main` if not specified.

### gwt-add 
```shell
gwt-add <repo_dir> <branch_name> [base_branch_or_commit_sha]
```

+ `<repo_dir>`: The directory where the repository was cloned using gwt-clone.
+ `<branch_name>`: The name of the branch to add as a worktree.
+ `[base_branch_or_commit_sha]` (optional): The base branch or commit SHA to create the new branch from. If not specified, the branch will be created from the latest commit of the default branch.

#### Examples
1. Create a new branch from the latest commit of the default branch: 
```shell
gwt-add repo.worktrees new-feature
```
2. Create a new branch from another existing branch:
```shell
gwt-add repo.worktrees new-feature development
```
3. Create a new branch from a specific historical commit:
```shell
gwt-add repo.worktrees bugfix abc1234
```

## Workings
### gwt-clone
This command will:

1. Clone the repository `https://github.com/user/repo.git` as a bare repository.
2. Create a directory structure for the worktree.
3. Add the main branch main to the worktree.

The output folder structure will be 
```
/path/to/repo.worktrees/
    ├── .bare/          # Basic Git structure (bare repository)
    └── main/           # Folder with the main branch checked out
```

### gwt-add
This command will:

1. Create a new branch from the current state or a specific commit.
2. Add the new branch as a worktree.

The folder structure after adding branches will be:
```
/path/to/repo.worktrees/
    ├── .bare/                  # Basic Git structure (bare repository)
    ├── main/                   # Folder with the main branch checked out
    ├── feature-branch/         # Worktree for 'feature-branch'
    └── historical-branch/      # Worktree for 'historical-branch' created from a specific commit
```

# Requirements
+ Git must be installed and available in the system's PATH.
+ Bash shell.

# Error Handling
The script uses set `-euo pipefail` to ensure it exits on errors, undefined variables, or pipeline failures.

+ If no arguments are supplied, it prints an error message and usage instructions.
+ The scripts also check for the existence of necessary directories and Git configurations to ensure smooth operations.
