#!/bin/bash
# shellcheck disable=SC2154
# SC2154 (warning): VARIABLE is referenced but not assigned.

set -e

echo "$PWD"
ls 

echo "source: ${source}"
echo "paths: ${paths}"
echo "recursive: ${recursive}"
echo "jobs: ${jobs}"
echo "all: ${all}"
echo "action_path: ${action_path}"

# Ensure git annex added to path
echo "/usr/share/miniconda/bin" >> "${GITHUB_PATH}"
ls /usr/share/miniconda/bin
export PATH="/usr/share/miniconda/bin:$PATH"

ls "${action_path}"
python "${action_path}/scripts/run_datalad.py"
