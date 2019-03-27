#!/bin/bash

# local hooks
find .git/hooks -type l -exec rm {} \; && {
    ln -sf ../../.githooks/helpers.py .git/hooks/
    ln -sf ../../.githooks/post-checkout .git/hooks/
    ln -sf ../../.githooks/pre-commit .git/hooks/
    ln -sf ../../.githooks/pre-rebase .git/hooks/  
    ln -sf ../../.githooks/prepare-commit-msg .git/hooks/  
}

# server-side hooks
# unfortunately do not work on Bitbucket Cloud as of now

echo "[sanity check] ensure the symbolic links are OKAY"
ls -lhtra .git/hooks/