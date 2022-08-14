#!/bin/bash

set -e

# Show the user all relevant variables for debugging!
printf "user: ${user}\n"
printf "email: ${email}\n"
printf "repository: ${repository}\n"
printf "release: ${release}\n"
printf "branch: ${branch}\n"
printf "full_clone: ${full_clone}\n"
printf "install_root: ${install_root}\n"

# This is in the install instructions
git config --global --add user.name "${user}"
git config --global --add user.email  "${email}"

python -m pip install --upgrade pip

# Use datalad-installer for git annex
pip install datalad-installer
datalad-installer git-annex -m datalad/packages
git config --global filter.annex.process "git-annex filter-process"

# Do we have a release or a branch?
if [ "${release}" != "" ]; then
    printf "Installing datalad from release ${release}...\n"
    wget https://github.com/${repository}/archive/refs/tags/${release}.tar.gz
    pip install ${release}.tar.gz

# Branch install, either shallow or full clone
else
    if [[ "${full_clone}" != "true" ]]; then
        printf "Installing datalad from branch ${branch}...\n"
        pip install git+https://github.com/${repository}.git@${branch}
    else
        printf "Installing datalad from branch ${branch} with full clone into ${install_root}...\n"
        git clone -b ${branch} https://github.com/${repository} ${install_root}
        cd ${install_root}
        pip install .
        cd -
    fi
fi
