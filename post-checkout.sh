#!/bin/bash

#############################################
#
# CONFIGURATION VARIABLES - NON EDITABLE
#
#############################################
PREVIOUS_HEAD="$1"
NEW_HEAD="$2"
IS_BRANCH_CHECKOUT="$3"

#############################################
#
# CONFIGURATION VARIABLES - EDITABLE
# MODIFY WITH CAUTION
#
#############################################
declare -a ALLOWED_FROM_DEV_BRANCHES=("feature-1" "feature-2" "feature-3")
declare -a ALLOWED_FROM_MASTER_BRANCHES=("dev")

#############################################
#
# FUNCTIONS
#
#############################################
function get_current_branch() {
    git symbolic-ref --short -q HEAD
}

function get_previous_branch() {
    last_branch_full=`git rev-parse --symbolic-full-name @{-1}`
    shortened="${last_branch_full##*/}"
    echo "$shortened"
}

function go_to_previous_branch_and_delete_current_branch() {
    PREVIOUS_BRANCH="$1"
    CURRENT_BRANCH="$2"
    git checkout "${PREVIOUS_BRANCH}"
    git branch -D "${CURRENT_BRANCH}" 
}

#############################################
#
# MAIN
#
#############################################
if [ "$IS_BRANCH_CHECKOUT" == 1 ]; then

    PREVIOUS_BRANCH=`get_previous_branch`
    CURRENT_BRANCH=`get_current_branch`

    # allow checkout to master branch
    [ "${CURRENT_BRANCH}" == "master" ] && { exit 0; }
    
    # allow checkout to dev branch
    [ "${CURRENT_BRANCH}" == "dev" ] && { exit 0; }

    # prevent checkout to unallowed branch from dev 
    if [ "${PREVIOUS_BRANCH}" == "dev" ]; then

        for ALLOWED_BRANCH in "${ALLOWED_FROM_DEV_BRANCHES[@]}"; do
            [ "${CURRENT_BRANCH}" == "$ALLOWED_BRANCH" ] && { exit 0; }
        done

        go_to_previous_branch_and_delete_current_branch "${PREVIOUS_BRANCH}" "${CURRENT_BRANCH}" && {
            echo "";
            echo "YOU ARE NOT ALLOWED TO CREATED A BRANCH WITH THAT NAME.";
            echo "The list of allowed branches from *dev* are: ${ALLOWED_FROM_DEV_BRANCHES[@]}";
            exit 1;
        }
    fi

    # prevent checkout to unallowed branch from master 
    if [ "${PREVIOUS_BRANCH}" == "master" ]; then

        for ALLOWED_BRANCH in "${ALLOWED_FROM_MASTER_BRANCHES[@]}"; do
            [ "${CURRENT_BRANCH}" == "$ALLOWED_BRANCH" ] && { exit 0; }
        done

        go_to_previous_branch_and_delete_current_branch "${PREVIOUS_BRANCH}" "${CURRENT_BRANCH}" && {
            echo "";
            echo "YOU ARE NOT ALLOWED TO CREATED A BRANCH WITH THAT NAME.";
            echo "The list of allowed branches from *master* are: ${ALLOWED_FROM_MASTER_BRANCHES[@]}";
            exit 1;
        }
    fi
fi











