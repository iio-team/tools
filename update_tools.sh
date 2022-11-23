#!/bin/bash
set -e

if ! [[ $(git rev-parse --show-toplevel 2>/dev/null) == "$PWD" ]]; then
    echo "FATAL ERROR: the current folder is not the root of a git repository."
    exit 1
fi
if ! [[ "`basename "$PWD"`" =~ ^iiot-202[0-9]$ ]]; then
    echo "FATAL ERROR: the current folder does not correspond to a IIOT year."
    exit 1
fi

git submodule init
cd tools
git checkout main
git pull
cd ..
git add tools
