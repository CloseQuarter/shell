#!/bin/bash
# 1. read from json file
#     1. Has repo name
#     2. Has repo url
# 2. use credentials supplied
#     1. check if a branch exist
#     2. if yes 
#            1. CLone the branch 
#     3. else 
#             1. Create the branch
#             2. checkout the branch
#             3. edit
#             4. upload   

# credentials
REMOTE_URL="https://github.com/CloseQuarter/shell.git"

# get list of branches
list_of_branches=($(git branch -r))
echo "${list_of_branches[@]}"

declare -i -r TRUE=1
declare -i -r FALSE=0

# Assumes git repo and git tools exist
# check if a branch exists
function git_check_if_a_branch_exists()
{
    local readonly branch_name="${1}"

    # check if branch exists
    git show-ref --verify --quiet "refs/heads/${branch_name}"

    if [ "$?" -eq "0" ]
    then
        # branch exists
        echo ${TRUE}
    else
        # no such branch
        echo ${FALSE}
    fi 

}

function is_successful()
{
    if [ "$?" -eq "0" ]
    then
        echo ${TRUE}
    else
        echo ${FALSE}
    fi 
}
branch_name="trial"
branch_exists=$(git_check_if_a_branch_exists "${branch_name}")
echo ${branch_exists}
if [ "${branch_exists}" -eq "1" ]
then
    # branch exists
    echo "Branch Exists"
    # checkout the branch
    git checkout "${branch_name}" 
else
    # no such branch
    echo "no such branch"
    # create a branch and checkout
    git checkout -b "${branch_name}"
fi

# add files
file_name="temp.txt"
function add_a_file()
{
    file_name="${1}"
    touch "${file_name}"
    is_successful
}

add_a_file "${file_name}"

# add to git
git add ${file_name}
is_successful

# commit
git commit -m "trial_branch_test" temp.txt -v
is_successful

# push
git push origin "${branch_name}"
is_successful

# raise a pull req
 https://docs.atlassian.com/bitbucket-server/rest/4.9.1/bitbucket-rest.html#idp2022432


