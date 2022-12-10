#!/bin/bash
set -e

if [ "$1" == "" ]; then
    echo "usage: $(basename "$0") year"
    exit 0
fi

year=$1
folder=`realpath "${0%.sh}"`

echo "This script will create a new repository for IIOT year $year, cloning it into the current folder."
if git rev-parse --is-inside-work-tree 1>/dev/null 2>/dev/null; then
    echo "FATAL ERROR: the current folder is inside a git repository."
    exit 1
fi
echo "Press enter to proceed, CTRL-C to quit..."
read

gh auth login
gh repo create "iio-team/iiot-$year" --private --team everyone --clone
cd "iiot-$year"
git branch -M main
sed "s|YYYY|$year|g" "$folder/README.md" > README.md
cp -r "$folder/.gitignore" "$folder/.github" .
git add .
git commit -m "initial commit"
git push --set-upstream origin main
git submodule add git@github.com:iio-team/tools.git
git submodule init
git submodule update
git commit -m "added tools"
git push
