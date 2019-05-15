#!/bin/bash

# 1. be in git repo
# 2. verify we are in git repo
# 3. enumerate all remote repos
# 4. check if remore repo contains a branch with "-ci"
# 5. if yes -> checkout the branch
# 6. if no -> checkout develop or the latest branch
# 7.    create the new ci branch
 
DEBUG=0
function debug_print()
{
    local readonly to_print="${1}"

    if [ "${DEBUG}" -eq 1 ]
    then
        printf "${to_print}\n"
    else
        :
    fi
} 

function git_get_remote_name()
{
    # remote name
    local readonly remote_url="$( 
        git config --get remote.origin.url 
        )"

    echo "${remote_url}"
}

function git_enumerate_all_remote_branches()
{
    # remote name
    local readonly remote_url="$( 
        git_get_remote_name
        )"

    debug_print ${remote_url}

    # brances on remote repo
    local readonly branches_on_remote_repo=(
        $(
            git ls-remote -h "${remote_url}"
        )
    )

    for branch in "${branches_on_remote_repo[@]}"
    do
        debug_print ${branch}
    done

    echo "${branches_on_remote_repo[@]}" 
}

function git_filter_branch_with_predicate()
{
    local readonly default_predicate="-ci"
    local readonly predicate="${1}"

    if [ -z "${predicate}" ]
    then
        branch_name="${default_predicate}"
    fi

    local readonly branches_on_remote_repo=(
        $(
            git_enumerate_all_remote_branches
        )
    )

    local ci_branches=()
    for branch in "${branches_on_remote_repo[@]}"
    do
        debug_print ${branch}
        if [[ "${branch}" =~ "${predicate}" ]]
        then
            ci_branches+=( "${branch}" )
        else
            :
        fi
    done

    for branch in "${ci_branches[@]}"
    do
        debug_print ${branch}
    done

    echo "${ci_branches[@]}" 
}

function git_add_ci_branch()
{
    local readonly default_ci_branch_name="trial"
    local ci_branch_name="${1}"
    
    if [ -z "${ci_branch_name}" ]
    then
        ci_branch_name="${default_ci_branch_name}"
    fi

    # check if CI branch exists
    local readonly ci_branches=(
        $(
            git_filter_branch_with_predicate "${ci_branch_name}"
        )
    )
    
    DEBUG=1
    for branch in "${ci_branches[@]}"
    do
        debug_print ${branch}
    done

    # no CI branch
    if [ -z "${ci_branches}" ]
    then
        debug_print "make new ci branch"
    else
        debug_print "checkout ci branch"
    fi
    DEBUG=0
}

git_add_ci_branch

# pass barnch without refs/heads
function git_check_if_branch_exists()
{
    local readonly default_branch_name="master"
    local branch_name="${1}"
    
    if [ -z "${branch_name}" ]
    then
        branch_name="${default_branch_name}"
    fi

    # remote name
    local readonly remote_url="$( 
        git_get_remote_name
        )"
    debug_print "$remote_url"
    
    local readonly branch_exists=$(
        git ls-remote --heads "${remote_url}" "${branch_name}"
    )

    if [[ -z "${branch_exists}" ]]
    then
        echo 1
    else
        echo 0
    fi 
}

function git_add_new_branch()
{
    local readonly default_ci_branch_name=""
    local readonly default_branch="develop"

    # git_check_if_branch_exists
    local readonly branch_exists=$(
        git_check_if_branch_exists "${default_branch}"  
        )

    DEBUG=1
    debug_print ${branch_exists}
    
    DEBUG=1
    if [[ "${branch_exists}" -eq "0" ]]
    then
        debug_print "branch %s exists" "${default_branch}"
    else
        debug_print "branch %s doesnt't exist" "${default_branch}"
    fi
    DEBUG=0 

}

git_add_new_branch