# README

A GitHub Action for mirroring a repository to another repository on GitHub, GitLab, BitBucket, AWS CodeCommit, etc.

This will copy all commits, branches and tags.

>⚠️ Note that the other settings will not be copied. Please check which branch is 'default branch' after the first mirroring.

## Usage

Customize following example workflow and save as .github/workflows/main.yml on your source repository.

cf. [Creating and using secrets](https://help.github.com/en/articles/virtual-environments-for-github-actions#creating-and-using-secrets-encrypted-variables) .

```yaml
name: Mirroring

on: [push, delete]

jobs:
  to_gitlab:
    runs-on: ubuntu-18.04
    steps:                                              # <-- must use actions/checkout@v1 before mirroring!
    - uses: actions/checkout@v1
    - uses: pixta-dev/repository-mirroring-action@v1
      with:
        target_repo_url:
          git@gitlab.com:<username>/<target_repository_name>.git
        ssh_private_key:                                # <-- use 'secrets' to pass credential information.
          ${{ secrets.GITLAB_SSH_PRIVATE_KEY }}

  to_codecommit:                                        # <-- different jobs are executed in parallel.
    runs-on: ubuntu-18.04
    steps:
    - uses: actions/checkout@v1
    - uses: pixta-dev/repository-mirroring-action@v1
      with:
        target_repo_url:
          ssh://git-codecommit.<somewhere>.amazonaws.com/v1/repos/<target_repository_name>
        ssh_private_key:
          ${{ secrets.CODECOMMIT_SSH_PRIVATE_KEY }}
        ssh_username:                                   # <-- (for codecommit) you need to specify ssh-key-id as ssh username.
          ${{ secrets.CODECOMMIT_SSH_PRIVATE_KEY_ID }}
```
