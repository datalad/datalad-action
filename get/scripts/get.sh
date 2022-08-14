#!/bin/bash

set -e

echo $PWD
ls 

printf "source: ${source}\n"
printf "paths: ${paths}\n"
printf "recursive: ${recursive}\n"
printf "jobs: ${jobs}\n"
printf "all: ${all}\n"
printf "action_path: ${action_path}\n"

# Ensure git annex added to path
echo "/usr/share/miniconda/bin" >> ${GITHUB_PATH}
ls /usr/share/miniconda/bin
export PATH=/usr/share/miniconda/bin:$PATH

ls ${action_path}
python ${action_path}/scripts/run_datalad.py
