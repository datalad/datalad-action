#!/bin/bash

set -eu

echo "$PWD"
ls 

action_root=$(dirname "$ACTION_PATH")
echo "Action root is ${action_root}"
ls "${action_root}"
echo "action_root=${action_root}" >> "$GITHUB_ENV"
