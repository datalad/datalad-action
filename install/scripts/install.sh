#!/bin/bash
# shellcheck disable=SC2154
# SC2154 (warning): VARIABLE is referenced but not assigned.

set -e

# Show the user all relevant variables for debugging!
echo "user: ${user}"
echo "email: ${email}"
echo "repository: ${repository}"
echo "release: ${release}"
echo "branch: ${branch}"
echo "full_clone: ${full_clone}"
echo "install_root: ${install_root}"

# This is in the install instructions
git config --global --add user.name "${user}"
git config --global --add user.email  "${email}"

python3 -m pip install --upgrade pip

# Install git annex
python3 -m pip install datalad-installer

datalad-installer git-annex
git config --global filter.annex.process "git-annex filter-process"

# Ensure git annex added to path
# Datalad needs to be installed to this conda environment
echo "$CONDA/bin" >> "${GITHUB_PATH}"
export PATH="$CONDA/bin:$PATH"
command -v pip

# Do we have a release or a branch?
if [ "${release}" != "" ]; then
    echo "Installing datalad from release ${release}..."
    wget "https://github.com/${repository}/archive/refs/tags/${release}.tar.gz"
    pip install "${release}.tar.gz"

# Branch install, either shallow or full clone
else
    if [[ "${full_clone}" != "true" ]]; then
        echo "Installing datalad from branch ${branch}..."
        pip install "git+https://github.com/${repository}.git@${branch}"
    else
        echo "Installing datalad from branch ${branch} with full clone into ${install_root}..."
        git clone -b "${branch}" "https://github.com/${repository}" "${install_root}"
        cd "${install_root}"
        pip install .
        cd -
    fi
fi
