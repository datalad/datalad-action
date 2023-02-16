#!/bin/bash
# shellcheck disable=SC2154
# SC2154 (warning): VARIABLE is referenced but not assigned.

set -e

echo "DEBUG INFO:"
set -x
echo "$PWD"
ls
bash --version
which -a bash
set +x

echo "source: ${source}"
echo "dataset_path: ${dataset_path}"
echo "paths: ${paths}"
echo "recursive: ${recursive}"
echo "globstar: ${globstar}"
echo "jobs: ${jobs}"
echo "all: ${all}"
echo "action_path: ${action_path}"

istrue() {
    echo "$@" | grep -q -i -e '^true$'
}

# Ensure git annex added to path
echo "$CONDA/bin" >> "${GITHUB_PATH}"
export PATH=$CONDA/bin:$PATH

if istrue "$globstar"; then
	# ** globbing support
	shopt -s globstar
fi

# set -x  # to ease debugging etc

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
	set -x
	set +e
    PS4='+${LINENO}: '
	set +u
	echo "DEBUG a little"
	echo $paths
	ls -l $paths
	eval ls -ld "$paths"
	eval ls -ld $paths
    echo $paths | xargs ls -l
    # use ls to get them expanded?
    /bin/ls -d1 $paths | xargs ls -l
    /bin/ls -d1 $paths | tr '\n' '\0' | xargs -0 ls -l
    eval /bin/ls -d1 "$paths" | xargs ls -l
    eval /bin/ls -d1 "$paths" | tr '\n' '\0' | xargs -0 ls -l
    echo "$paths" | python3 -c "import os, glob, sys; [ sys.stdout.write(f'{x}\000') for x in sum([glob.glob(x.rstrip(os.linesep)) for x in sys.stdin.readlines()], [])]" | xargs -0 ls -1d
    echo "$paths" | python3 -c "import os, glob, sys; [ sys.stdout.write(f'{x}\000') for x in sum([glob.glob(x.rstrip(os.linesep)) for x in sys.stdin.readlines()], [])]" | xargs -0 datalad get
	# shellcheck disable=SC2086
    #echo $paths | xargs datalad get
fi
