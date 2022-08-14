#!/bin/bash

set -e

echo $PWD
ls 

action_root=$(dirname $ACTION_PATH)
printf "Action root is ${action_root}\n"
ls ${action_root}
echo "action_root=${action_root}" >> $GITHUB_ENV
