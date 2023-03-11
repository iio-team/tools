#!/bin/bash

if [ "$1" == "" ]; then
    echo "usage:"
    echo "  $0 -a        # cleans every contest"
    echo "  $0 <contest> # cleans a contest"
    exit 1
fi
contest="$1"
if [ "$1" == "-a" ]; then
    contest="*"
fi

for t in $contest/*/task.yaml; do
    task="${t%/task.yaml}"
    echo -n "$task..."
    cd $task
    task-maker-tools clear
    cd ../..
done
echo "done."
