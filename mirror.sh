#!/usr/bin/env sh
set -eu

/setup-ssh.sh

export GIT_SSH_COMMAND="ssh -v -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no -l $INPUT_SSH_USERNAME"

# Cleanup any previously created remotes to make sure adding the mirror never fails
git remote remove mirror || true

git remote add mirror "$INPUT_TARGET_REPO_URL"
git push --tags --force --prune mirror "refs/remotes/origin/*:refs/heads/*"
