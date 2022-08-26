#!/bin/bash
# shellcheck disable=SC2154
# SC2154 (warning): VARIABLE is referenced but not assigned.

set -e

echo "$PWD"
ls 

echo "source: ${source}"
echo "dataset_path: ${dataset_path}"
echo "paths: ${paths}"
echo "recursive: ${recursive}"
echo "jobs: ${jobs}"
echo "all: ${all}"
echo "action_path: ${action_path}"

istrue() {
    echo "$@" | grep -q -i -e '^true$'
}

# set -x  # to ease debugging etc

# to ease debugging locally -- if no GITHUB_PATH, do not bother
if [ -n "${GITHUB_PATH}" ]; then
    # Ensure git annex added to path
    echo "/usr/share/miniconda/bin" >> "${GITHUB_PATH}"
    ls /usr/share/miniconda/bin
    export PATH="/usr/share/miniconda/bin:$PATH"
fi

# compose command depending on the available options
#
# We will use "-f '{path}'" to unambigously discover where the dataset is installed
# but care must be taken since in case of --recursive could be multiple and only first one
# should be taken
CMD=(datalad -f '{path}' install --source "$source")

# target dataset_path is optional
[ -n "$dataset_path" ] && CMD+=("$dataset_path")

# 1-to-1 flags 
# shellcheck disable=SC2043  # just for now since we have only 1, but keeping logic
for v in recursive; do
    vval="${!v}"
    if [ -n "$vval" ] && istrue "$vval"; then
        CMD+=("--$v")
    fi
done

# 1-to-1 options with values
# shellcheck disable=SC2043  # just for now since we have only 1, but keeping logic
for v in jobs; do
    vval="${!v}"
    if [ -n "$vval" ]; then
        CMD+=("--$v" "$vval")
    fi
done

# custom (might want to rename)
istrue "$all" && CMD+=(--get-data)

echo "Installing running a command" "${CMD[@]}"
# shellcheck disable=SC2207  # TODO: Prefer mapfile or read -a to split command output (or quote to avoid splitting)
installed_path=( $("${CMD[@]}") )

if [ -n "$paths" ]; then
    echo "Getting paths"
    cd "${installed_path[0]}"
    echo "$paths" | xargs datalad get
fi
