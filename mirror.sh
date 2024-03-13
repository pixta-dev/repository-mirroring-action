#!/usr/bin/env sh
set -xeu

SSH_PRIVATE_KEY_FILE="${HOME}/.ssh/id_ed25519"
REMOTE_NAME="mirror"

function setup_ssh {
    # Creates the private key file
    mkdir -p $(dirname "${SSH_PRIVATE_KEY_FILE}")
    echo "${INPUT_SSH_PRIVATE_KEY}" > "${SSH_PRIVATE_KEY_FILE}"
    chmod 600 "${SSH_PRIVATE_KEY_FILE}"

    # Unlock the private key in order to avoid the ssh-add prompt
    if [[ -n "${INPUT_SSH_PRIVATE_KEY_PASSPHRASE}" ]]; then
        echo "" | ssh-keygen -p -P "${INPUT_SSH_PRIVATE_KEY_PASSPHRASE}" -f "${SSH_PRIVATE_KEY_FILE}"
    fi
}

function clean_up {
    local remote="${1}"
    git remote remove "${remote}"
}

function mirror {
    export GIT_SSH_COMMAND="ssh -v -i ${SSH_PRIVATE_KEY_FILE} -l ${INPUT_SSH_USERNAME} -o StrictHostKeyChecking=no"
    git remote add "${REMOTE_NAME}" "${INPUT_TARGET_REPO_URL}"
    git push --tags --force --prune "${REMOTE_NAME}" "refs/remotes/origin/*:refs/heads/*"
    # NOTE: Since `post` execution is not supported for local action from './' for now, we need to
    # run the command by hand.
    clean_up "${REMOTE_NAME}"
}

function test_clone_with_private_key {
    export GIT_SSH_COMMAND="ssh -v -i ${SSH_PRIVATE_KEY_FILE} -l git -o StrictHostKeyChecking=no"
    rm -rf repository
    git clone "${INPUT_TARGET_REPO_URL}" repository
    cd repository
    echo "clone is a success"
}

function main {
    setup_ssh
    mirror
}

main
